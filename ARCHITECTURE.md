# TdC OS: technical overview

TdC OS is a data and decision platform on **Postgres (Supabase)** that powers tech-touch customer success operations for a subscription business. It closes the loop **observe → decide → act → learn** over the subscriber base.

## Architecture

```
Stripe ─┐                                          ┌─> ActiveCampaign (workflows)
        ├─> Ingestion ─> Identity ─> Warehouse ─> Signals ─> Decision ─┤
AC ─────┘                                          └─> Monday.com (queues)
                               ▲                                     │
                               └─────────── Learning <───────────────┘
```

## Layers

**1. Ingestion**
- **Stripe:** customers, subscriptions and invoices, plus a field-level change log (`stripe_events_log`) that records, for example, changes to `current_period_end`.
- **ActiveCampaign:** contacts, custom fields, tags and each contact's membership in automations.

**2. Identity resolution**
An identity table links each Stripe customer to its ActiveCampaign contact. This is what makes it possible to trigger flows from billing events.

**3. Warehouse and daily snapshots**
Data lives in Postgres. Every day a per-subscriber snapshot is taken: status, plan, usage, health (green, yellow, red) and risk level.

**4. KPI layer**
Keeps the **official Stripe churn** and a **TdC OS reconstruction** side by side to decompose the difference. The two are never summed or substituted for each other.

**5. Signal engine**
Detects patterns in code, each with its eligible population and MRR at risk. The context of a signal is frozen at the moment it fires.

**6. Workflow assessment**
A workflow registry links each ActiveCampaign flow to the signal it is supposed to handle. The assessment says whether the automation exists, whether it is active and whether it executes, and classifies the gap (execution, automation or strategy). Results are labeled as correlation, not causation, with minimum-sample guards. Links between workflows and automations are confirmed by a human.

**7. Decision engine**
Produces two queues: a customer queue with the next best action (monitor, test, human intervention) and a machine queue with fixes to flows and configuration.

**8. Orchestration and action**
Actions become automations in ActiveCampaign and items in Monday.com for the human team.

**9. Forecasting and learning**
- Projects the month's churn with baseline and analog methods, with error measured in backtests.
- Records the outcome of each intervention to feed later decisions.

**10. Access control**
An allow-list of authorized users with auditing. Being authenticated in Supabase is not enough.

## Execution

Modules run as a pipeline, in this order: sync → forecast → automation assessment → workflow assessment → decision → Monday.com integration → learning. Each run is logged with status and duration.

## In one sentence

TdC OS is an orchestration layer on top of Stripe and ActiveCampaign: it unifies data by identity, computes KPIs and signals, decides the next best action per customer and executes it through automations and Monday.com, with forecasting and learning closing the loop.
