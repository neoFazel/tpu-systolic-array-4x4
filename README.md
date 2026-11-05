# tpu-systolic-array-4x4

## processing element(PE) verification
PE described in previous commit now it's time to verify it via a testbench

---

### Step 1: Define Verification Scenarios
different functionalitis of PE module is as follow:
- **Reset behaviour**
- **Single Mac operation**
- **accumulation sequence**: assert valid mux_21 control 
- **data forwarding**: after one clock the value of a_in appears in a_out and similary the same function for b_in and b_out.
- **boundry values**: make sure there is no over-flow issue.

### step 2: structing a self-checking testbench
which include:
- **clock and reset generation**
- **device under verification(DUV) instantiation**
- **stimulus generation**
- **self-checking(scoreboard with golden data)**





