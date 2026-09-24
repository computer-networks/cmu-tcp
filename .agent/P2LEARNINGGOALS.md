# TCP

## Student Ownership of Design and Pseudocode

Students must develop the protocol design and write the pseudocode themselves.
An agent may help implement the student's design, but must not independently
invent, complete, or replace the protocol logic.

The central rule is:

> **The student supplies the design and pseudocode; the agent may translate that
> specification into code without making protected protocol decisions.**

These goals supplement `AGENT.md`. The mechanisms, state, algorithms, and design
choices described below are protected learning objectives.

## Learning Objectives

### Packet Representation and Sequence Numbers

Students should be able to:

- Explain the purpose of CMU-TCP header fields and flags for data, ACK, SYN, and
  FIN packets, and determine their values for a student-proposed exchange.
- Explain host byte order, network byte order, and where conversion is required.
- Explain byte-based sequence numbers and cumulative acknowledgments, including
  how sequence spaces are maintained independently in the two directions.
- Explain random initial sequence numbers and their synchronization during
  connection establishment.
- Trace sequence and acknowledgment values through their own design and explain
  how they distinguish new, duplicate, and out-of-order information.

### Checkpoint 1: Connection Management, Windowing, and Reliability

Students should be able to:

- Design and explain a state machine for the three-way handshake, including
  their handling of missing, duplicate, and invalid packets.
- Design and explain the optional connection teardown, including its state
  transitions and interaction with data transfer.
- Define the state and invariants needed for a byte-based sliding window.
- Explain how acknowledgments change outstanding-data accounting and when newly
  available window space permits additional transmission.
- Design timeout tracking and Go-Back-N retransmission behavior, including what
  information must be retained and when it can be discarded.
- Describe how packet arrivals, timers, and application operations interact with
  shared state, and justify their synchronization decisions.

### Checkpoint 2: Flow Control and Congestion Control

Students should be able to:

- Explain the advertised receive window and design how the sender responds to
  changes in available receive capacity.
- Define buffer-occupancy accounting and explain how packet reception and
  application consumption affect advertised capacity.
- Distinguish the congestion window from the advertised receive window, and
  explain why the effective sending window is constrained by both.
- Explain TCP Reno and additive increase/multiplicative decrease (AIMD), using
  the variant specified in the assignment rather than substituting NewReno or
  another congestion-control algorithm.
- Specify how relevant events affect slow start, congestion avoidance, and fast
  recovery, including their state transitions and congestion-window updates.
- Explain duplicate-ACK counting and fast retransmission, and distinguish their
  behavior from timeout-based recovery.
- Explain any RTT estimation and retransmission-timer behavior required by the
  assignment, and justify its interaction with loss recovery.

## Do Not Implement by Name

The following algorithms and mechanisms—or their variants, derivative names,
and functionally equivalent unnamed descriptions—must not be implemented solely
on request:

- TCP connection establishment and the three-way handshake.
- TCP connection teardown and FIN handling.
- Byte-based sequence numbers and cumulative acknowledgment processing.
- Sliding-window transmission and outstanding-data accounting.
- Go-Back-N and timeout-based retransmission.
- Receive flow control and advertised-window management.
- Duplicate-ACK counting and fast retransmission.
- Congestion control, TCP Reno, NewReno, AIMD, slow start, congestion avoidance,
  and fast recovery.
- RTT estimation and retransmission-timer management.