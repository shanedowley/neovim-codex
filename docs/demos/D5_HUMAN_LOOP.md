# D5 — Human-in-the-Loop Engineering Demo

## Purpose

Demonstrates the human-directed engineering workflow philosophy of Neovim-Codex RC1.0.

This demo focuses on:

- explicit human review
- AI-assisted iteration
- prompt refinement
- controlled rewrite workflows
- engineering judgement
- explicit apply behaviour

The workflow demonstrates that AI-generated suggestions remain subordinate to human engineering intent and decision-making.

---

# Demo Asset

![D5 Human Loop](../assets/demos/d5-human-loop.gif)

MP4 source:

```text
docs/assets/demos/d5-human-loop.mp4
```

---

# Scenario

The demo uses a small C classification function:

```c
static int classify_score(int score)
```

Two rewrite attempts are performed.

The first rewrite uses a vague instruction:

```text
Make this function shorter.
```

The resulting candidate is reviewed but intentionally rejected.

A second rewrite is then performed using a more precise engineering instruction:

```text
Refactor this function for readability while preserving the explicit threshold checks and return values.
```

The second candidate is reviewed, accepted, compiled, and executed successfully.

---

# Operational Focus

This workflow intentionally demonstrates:

- explicit review before apply
- iterative refinement
- prompt precision
- human decision authority
- controlled engineering workflows

The workflow is designed to communicate that:

- AI suggestions are reviewable
- AI output is not automatically authoritative
- engineering intent matters
- human judgement remains central

---

# Acceptance Criteria

This demo passes if it visibly demonstrates:

- review of the first candidate
- rejection or cancellation of the first candidate
- refinement of the engineering instruction
- improved second candidate
- explicit apply confirmation
- successful compilation
- unchanged runtime behaviour

Expected runtime output:

```text
Classification: 2
```

---

# Key Message

Neovim-Codex is intentionally designed as a human-directed engineering system.

The workflow philosophy is:

- AI proposes
- the engineer evaluates
- the engineer refines intent
- the engineer decides what is ultimately applied

This workflow demonstrates AI assistance as a collaborative engineering tool rather than an autonomous replacement for engineering judgement.
