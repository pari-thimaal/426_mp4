//===----------------------------------------------------------------------===//
//
/// A register allocator simplified from RegAllocFast.cpp
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegAllocRegistry.h"
#include "llvm/CodeGen/RegisterClassInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"

#include <map>
#include <set>

using namespace llvm;

#define DEBUG_TYPE "regalloc"

STATISTIC(NumStores, "Number of stores added");
STATISTIC(NumLoads , "Number of loads added");

namespace {
  /// This is class where you will implement your register allocator in
  class RegAllocSimple : public MachineFunctionPass {
  public:
    static char ID;
    RegAllocSimple() : MachineFunctionPass(ID) {}

  private:
    /// Some information that might be useful for register allocation
    /// They are initialized in runOnMachineFunction
    MachineFrameInfo *MFI;
    MachineRegisterInfo *MRI;
    const TargetRegisterInfo *TRI;
    const TargetInstrInfo *TII;
    RegisterClassInfo RegClassInfo;

    // TODO: maintain information about live registers
    std::map<Register, MCPhysReg> LiveVirtRegs = {};
    std::map<Register, int> SpillMap = {};
    std::map<Register, bool> IsVirtRegDirty = {};
    std::set<MCPhysReg> UsedPhysRegs = {};
    std::set<MCPhysReg> CurrentInstrPhysRegs;

  public:
    StringRef getPassName() const override { return "Simple Register Allocator"; }

    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.setPreservesCFG();
      MachineFunctionPass::getAnalysisUsage(AU);
    }

    /// Ask the Machine IR verifier to check some simple properties
    /// Enabled with the -verify-machineinstrs flag in llc
    MachineFunctionProperties getRequiredProperties() const override {
      return MachineFunctionProperties().set(
          MachineFunctionProperties::Property::NoPHIs);
    }

    MachineFunctionProperties getSetProperties() const override {
      return MachineFunctionProperties().set(
          MachineFunctionProperties::Property::NoVRegs);
    }

    MachineFunctionProperties getClearedProperties() const override {
      return MachineFunctionProperties().set(
        MachineFunctionProperties::Property::IsSSA);
    }

  private:
    // helper functions -------
    // given in mp4.pdf
    void setMachineOperandToPhysReg(MachineOperand &MO, Register PhysReg) {
      unsigned SubRegIdx = MO.getSubReg();
      if (SubRegIdx != 0) {
        PhysReg = TRI->getSubReg(PhysReg, SubRegIdx);
        MO.setSubReg(0);
      }
      MO.setReg(PhysReg);
      if (MO.isKill()) {
        MO.setIsKill(false);
      } else if (MO.isDead()) {
        MO.setIsDead(false);
      }
      MO.setIsRenamable();
    }

    int getStackSlot(Register VirtReg) {
      if(SpillMap.find(VirtReg) != SpillMap.end()) {
        return SpillMap[VirtReg];
      }

      const TargetRegisterClass *RC = MRI->getRegClass(VirtReg);
      unsigned Size = TRI->getSpillSize(*RC);
      Align Alignment = TRI->getSpillAlign(*RC);
  
      int FrameIdx = MFI->CreateSpillStackObject(Size, Alignment);
      SpillMap[VirtReg] = FrameIdx;
      return FrameIdx;
    }

    void reloadVirtualRegister(Register VirtReg, MCPhysReg PhysReg, MachineBasicBlock &MBB, MachineBasicBlock::iterator InsertPt) {
      int FrameIdx = getStackSlot(VirtReg);
      const TargetRegisterClass *RC = MRI->getRegClass(VirtReg);
      TII->loadRegFromStackSlot(MBB, InsertPt, PhysReg, FrameIdx, RC, TRI, Register());
      NumLoads++;
      IsVirtRegDirty[VirtReg] = false;
    }

    bool isPhysRegAvailable(MCPhysReg PhysReg) {
      return UsedPhysRegs.count(PhysReg) == 0;
    }

    void spillVirtualRegister(Register VirtReg, MCPhysReg PhysReg, MachineBasicBlock &MBB, MachineBasicBlock::iterator InsertPt) {
      int FrameIdx = getStackSlot(VirtReg);
      const TargetRegisterClass *RC = MRI->getRegClass(VirtReg);
      TII->storeRegToStackSlot(MBB, MBB.end(), PhysReg, true, FrameIdx, RC, TRI, Register());
      NumStores++;
      IsVirtRegDirty[VirtReg] = false;
    }

    // end of helper functions -------

    /// Allocate physical register for virtual register operand
    void allocateOperand(MachineOperand &MO, Register VirtReg, bool is_use) {
      // TODO: allocate physical register for a virtual register
      MachineInstr *MI = MO.getParent();
      MachineBasicBlock *MBB = MI->getParent();

      // check if already allocated
      if (LiveVirtRegs.count(VirtReg)) {
        MCPhysReg PhysReg = LiveVirtRegs[VirtReg];
        setMachineOperandToPhysReg(MO, PhysReg);
        return;
      }

      // get registers from relevant class (EAX/RAX etc)
      const TargetRegisterClass *RC = MRI->getRegClass(VirtReg);
      ArrayRef<MCPhysReg> Order = RegClassInfo.getOrder(RC);
      MCPhysReg Found = 0;

      // try to find free physical register
      for (MCPhysReg PhysReg : Order) {
        if(CurrentInstrPhysRegs.count(PhysReg)) continue;

        if (isPhysRegAvailable(PhysReg)) {
          Found = PhysReg;
          break;
        }
      }

      // spill one if none free
      if (!Found) {
        for (MCPhysReg PhysReg : Order) { // does this need to be a for loop? first iteration should suffice
          // find virtual register mapped to this physical register
          Register VirtToSpill = 0;
          for (auto &Pair : LiveVirtRegs) {
            if (Pair.second == PhysReg) {
              VirtToSpill = Pair.first;
              break;
            }
          }

          if (VirtToSpill.isValid()) {
            // spill if dirty
            if (IsVirtRegDirty[VirtToSpill]) {
              spillVirtualRegister(VirtToSpill, PhysReg, *MBB, MI->getIterator());
            }

            // remove from live set
            LiveVirtRegs.erase(VirtToSpill);
            UsedPhysRegs.erase(PhysReg);
            Found = PhysReg;
            break;
          }
        }
      }

      // if this is a use, reload from stack if it was spilled before
      if (is_use && SpillMap.count(VirtReg)) {
        reloadVirtualRegister(VirtReg, Found, *MBB, MI->getIterator());
      }

      UsedPhysRegs.insert(Found);
      LiveVirtRegs[VirtReg] = Found;
      if (!is_use) {
        IsVirtRegDirty[VirtReg] = true;
      }
      setMachineOperandToPhysReg(MO, Found);
    }

    void allocateInstruction(MachineInstr &MI) {
      // TODO: find and allocate all virtual registers in MI
      // collect physical registers already used in this instruction
      CurrentInstrPhysRegs.clear();
      std::set<MCPhysReg> PhysRegsInInstr;
      for (MachineOperand &MO : MI.operands()) {
        if (MO.isReg() && MO.getReg().isValid()) {
          Register Reg = MO.getReg();
          if (Reg.isPhysical()) {
            PhysRegsInInstr.insert(Reg);
            UsedPhysRegs.insert(Reg); // may not be necessary
          }
        }
      }

      // allocate uses first
      for (MachineOperand &MO : MI.operands()) {
        if (MO.isReg() && MO.isUse() && MO.getReg().isVirtual()) {
          Register VirtReg = MO.getReg();
          allocateOperand(MO, VirtReg, true);
          if(LiveVirtRegs.count(VirtReg)) CurrentInstrPhysRegs.insert(LiveVirtRegs[VirtReg]);
        }
      }

      // spill clobbered registers before a function call
      for (MachineOperand &MO : MI.operands()) {
        if (MO.isRegMask()) {
          const uint32_t *Mask = MO.getRegMask();
          std::vector<Register> ToSpill;

          for (auto &Pair : LiveVirtRegs) {
            Register VirtReg = Pair.first;
            MCPhysReg PhysReg = Pair.second;

            if (MachineOperand::clobbersPhysReg(Mask, PhysReg)) {
              ToSpill.push_back(VirtReg);
            }
          }

          for (Register VirtReg : ToSpill) {
            MCPhysReg PhysReg = LiveVirtRegs[VirtReg];
            if (IsVirtRegDirty[VirtReg]) {
              spillVirtualRegister(VirtReg, PhysReg, *MI.getParent(), MI.getIterator());
            }
            LiveVirtRegs.erase(VirtReg);
            UsedPhysRegs.erase(PhysReg);
          }
        }
      }

      // allocate defs
      for (MachineOperand &MO : MI.operands()) {
        if (MO.isReg() && MO.isDef() && MO.getReg().isVirtual()) {
          Register VirtReg = MO.getReg();
          allocateOperand(MO, VirtReg, false);
          if(LiveVirtRegs.count(VirtReg)) CurrentInstrPhysRegs.insert(LiveVirtRegs[VirtReg]);
        }
      }

      // remove physical registers from UsedPhysRegs unless they're holding a virtual register
      // i.e. registers req to be free in this instn for intermediate purpose but not actually holding a register
      for (MCPhysReg PhysReg : PhysRegsInInstr) {
        bool HoldsVirtReg = false;
        for (auto &Pair : LiveVirtRegs) {
          if (Pair.second == PhysReg) {
            HoldsVirtReg = true;
            break;
          }
        }
        if (!HoldsVirtReg) {
          UsedPhysRegs.erase(PhysReg);
        }
      }
    }

    void allocateBasicBlock(MachineBasicBlock &MBB) {
      // TODO: allocate each instruction
      // TODO: spill all live registers at the end
      LiveVirtRegs.clear();
      UsedPhysRegs.clear();

      // populate UsedPhysRegs with reserved registers
      for(MachineBasicBlock::RegisterMaskPair LiveIn : MBB.liveins()) {
        UsedPhysRegs.insert(LiveIn.PhysReg);
      }

      for (MachineInstr &MI : MBB) {
        allocateInstruction(MI);
      }

      // spill live instructions at the end, if it is not a return instruction
      if (!MBB.empty() && !MBB.back().isReturn()) {
        for (auto Pair : LiveVirtRegs) {
          Register VirtReg = Pair.first;
          MCPhysReg PhysReg = Pair.second;
          if (IsVirtRegDirty[VirtReg]) {
            spillVirtualRegister(VirtReg, PhysReg, MBB, MBB.end());
          }
        }
      }

      UsedPhysRegs.clear();
    }

    bool runOnMachineFunction(MachineFunction &MF) override {
      dbgs() << "simple regalloc running on: " << MF.getName() << "\n";

      // outs() << "simple regalloc not implemented\n";
      // abort();

      // Get some useful information about the target
      MRI = &MF.getRegInfo();
      const TargetSubtargetInfo &STI = MF.getSubtarget();
      TRI = STI.getRegisterInfo();
      TII = STI.getInstrInfo();
      MFI = &MF.getFrameInfo();
      MRI->freezeReservedRegs();
      RegClassInfo.runOnMachineFunction(MF);

      // Allocate each basic block locally
      for (MachineBasicBlock &MBB : MF) {
        allocateBasicBlock(MBB);
      }

      MRI->clearVirtRegs();

      return true;
    }
  };
}

/// Create the initializer and register the pass
char RegAllocSimple::ID = 0;
FunctionPass *llvm::createSimpleRegisterAllocator() { return new RegAllocSimple(); }
INITIALIZE_PASS(RegAllocSimple, "regallocsimple", "Simple Register Allocator", false, false)
static RegisterRegAlloc simpleRegAlloc("simple", "simple register allocator", createSimpleRegisterAllocator);
