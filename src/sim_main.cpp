#include <memory>
#include <verilated.h>
#include <verilated_fst_c.h>

#include "VTestbench.h"

int main(int argc, char **argv) {
    // Construct a VerilatedContext to hold simulation time, etc.
    // Multiple modules (made later below with Vtop) may share the same
    // context to share time, or modules may have different contexts if
    // they should be independent from each other.

    // Using unique_ptr is similar to
    // "VerilatedContext* contextp = new VerilatedContext" then deleting at end.
    const std::unique_ptr<VerilatedContext> contextp{ new VerilatedContext };
    // Do not instead make Vtop as a file-scope static variable, as the
    // "C++ static initialization order fiasco" may cause a crash

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    contextp->debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs argument parsing
    contextp->randReset(0); // 0 -> reset all bits to zero

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);

    // Construct the Verilated model, from Vtop.h generated from Verilating
    // "top.v". Using unique_ptr is similar to "Vtop* top = new Vtop" then
    // deleting at end. "TOP" will be the hierarchical name of the module.
    const std::unique_ptr<VTestbench> Testbench{ new VTestbench(contextp.get(), "TopTestbench") };

    // waveform setup
    VerilatedFstC *tfp = new VerilatedFstC;
    Testbench->trace(tfp, 99);
    tfp->open("waveform.fst");

    // Simulate until $finish
    while (!contextp->gotFinish()) {
        contextp->timeInc(1);        // one timeprecision period passes...
        Testbench->eval();           // evaluate testbench module
        tfp->dump(contextp->time()); // dump waveform
    }
    // Final model cleanup
    Testbench->final();
    tfp->close();

    // Final simulation summary
    contextp->statsPrintSummary();
}
