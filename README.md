# TdC OS

Customer success operating system for subscription businesses. It syncs Stripe, ActiveCampaign and Monday.com into Postgres, scores customer health, forecasts churn, audits lifecycle workflows and queues recommended interventions for the CS team.

Built for a Brazilian medical-education subscription company (free trial into paid plans), where retention depends on whether new subscribers actually start using the product.

## How it works

TdC OS runs as a set of recurring jobs, each logged in a `sync_runs` table. A full run takes about 50 minutes.

1. **Ingestion.** Stripe (subscriptions, invoices, billing state) and ActiveCampaign (contacts, automations, workflow contacts) are synced into Postgres. Stripe is the source of truth for billing.
2. **Identity bridge.** A `customer_identity` table links the same person across Stripe, ActiveCampaign and Monday.com.
3. **Intelligence.** KPIs and history, segment health scores, churn and MRR forecasts, behavioral signals, and an assessment of each registered lifecycle workflow on coverage, execution, outcome and correlated churn. Each workflow gets a diagnosis (for example an execution gap).
4. **Action and learning.** Recommended interventions go into a customer queue and a machine queue, and are pushed to a Monday.com cockpit for the CS team. Outcomes and experiments are recorded, so the system learns which interventions work.

## Design principles

- Stripe is the source of truth for billing state.
- Every job run is logged.
- Workflow metrics are labeled as correlation, not causation, with minimum-sample guards.
- Links between workflows and ActiveCampaign automations are confirmed by a human.

## Stack

Postgres (Supabase), Stripe, ActiveCampaign, Monday.com.

## Repository contents

- `tdcos_schema.sql`: structure of the database (tables, views, functions, constraints and indexes). It contains no data. Row-level security policies, grants and triggers are not included, so it is a reference and not guaranteed to replay from scratch.

Built by [buiLTValue](https://builtvalue.kochpartners.com.br).
