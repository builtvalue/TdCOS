-- ============================================================================
-- TdC OS: database schema (structure only; no data)
-- Snapshot exported from the production Postgres (Supabase) on 2026-10-27.
-- Reference document: not guaranteed to replay as-is.
--   * Row-level-security policies, grants, identity/sequence settings and
--     triggers are not included.
--   * Tables reference auth.users (Supabase Auth schema).
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. TABLES
-- ----------------------------------------------------------------------------

CREATE TABLE public.ac_automation_contacts (
  contact_automation_id text NOT NULL,
  automation_id text NOT NULL,
  contact_id text NOT NULL,
  entered_at timestamp with time zone,
  exited_at timestamp with time zone,
  ac_status smallint,
  completed_elements integer,
  total_elements integer,
  last_block text,
  last_date timestamp with time zone,
  captured_at timestamp with time zone NOT NULL
);

CREATE TABLE public.ac_contact_tags (
  contact_id text NOT NULL,
  tag_id text NOT NULL,
  tag_name text,
  applied_at timestamp with time zone NOT NULL,
  removed_at timestamp with time zone
);

CREATE TABLE public.ac_contacts (
  id text NOT NULL,
  email text,
  phone text,
  firstname text,
  lastname text,
  cdate timestamp with time zone,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE public.ac_field_values (
  contact_id text NOT NULL,
  field_id text NOT NULL,
  field_name text,
  value text,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE public.automation_assessment (
  id bigint NOT NULL,
  assessment_date date NOT NULL DEFAULT CURRENT_DATE,
  signal_code text NOT NULL,
  automation_exists boolean NOT NULL DEFAULT false,
  automation_ids text[],
  automation_names text[],
  automation_active boolean,
  eligible_population integer,
  entered_population integer,
  coverage_rate numeric,
  execution_rate numeric,
  completion_rate numeric,
  reaction_rate numeric,
  outcome_rate numeric,
  trigger_quality text,
  criteria_quality text,
  coverage_quality text,
  flow_quality text,
  timing_quality text,
  copy_quality text,
  channel_quality text,
  outcome_quality text,
  gap_type text,
  gap_detail text,
  recommended_fix text,
  evidence jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.customer_daily_snapshot (
  id bigint NOT NULL,
  snapshot_date date NOT NULL,
  contact_id text,
  subscription_id text,
  stripe_status text,
  plan_interval text,
  health_score text,
  health_score_label text,
  segmento text,
  cancel_at_period_end boolean,
  captured_at timestamp with time zone NOT NULL DEFAULT now(),
  topics_started_60d numeric,
  topics_unique_visited_60d numeric,
  topics_completed_60d numeric,
  days_since_last_use numeric,
  sessions_7d numeric,
  activation_status text,
  risk_level text,
  plan_nickname text,
  plan_amount numeric,
  trial_end timestamp with time zone,
  canceled_at timestamp with time zone
);

CREATE TABLE public.customer_identity (
  id bigint NOT NULL,
  stripe_customer_id text,
  activecampaign_contact_id text,
  email text NOT NULL,
  identity_match_status text NOT NULL DEFAULT 'UNMATCHED'::text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE public.customer_queue (
  id bigint NOT NULL,
  queue_date date NOT NULL DEFAULT CURRENT_DATE,
  signal_id bigint,
  recommendation_id bigint,
  customer_id text,
  subscription_id text,
  email text,
  signal_code text,
  churn_type text,
  days_remaining integer,
  recoverability text,
  mrr_at_risk numeric,
  contexto_resumo text,
  automacao text,
  gap text,
  acao_recomendada text,
  canal text,
  prioridade numeric,
  rank integer,
  status text NOT NULL DEFAULT 'PENDING'::text,
  monday_item_id text,
  sent_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.forecast_outcomes (
  id bigint NOT NULL,
  forecast_id bigint NOT NULL,
  target_month text NOT NULL,
  forecast_value numeric NOT NULL,
  actual_value numeric,
  absolute_error numeric,
  signed_error numeric,
  days_before_close integer NOT NULL,
  metric text NOT NULL DEFAULT 'CHURN_RATE'::text,
  method text,
  avaliado_em timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.forecast_runs (
  forecast_id bigint NOT NULL,
  forecast_date date NOT NULL,
  target_month text NOT NULL,
  days_remaining integer NOT NULL,
  day_of_month integer NOT NULL,
  dias_no_mes integer NOT NULL,
  actual_churn_mtd integer,
  actual_rate_mtd numeric,
  forecast_total_churn integer,
  forecast_rate numeric,
  forecast_voluntary_churn integer,
  forecast_involuntary_churn integer,
  forecast_actionable_voluntary integer,
  forecast_actionable_involuntary integer,
  lower_bound numeric,
  upper_bound numeric,
  confidence text NOT NULL,
  confidence_reason text,
  method text NOT NULL,
  historical_analogs jsonb,
  model_version text NOT NULL DEFAULT 'v1'::text,
  detail jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.historical_snapshots (
  snapshot_date date NOT NULL,
  month text NOT NULL,
  day_of_month integer NOT NULL,
  dias_no_mes integer NOT NULL,
  subscriber_churn_actual numeric,
  active_subscribers integer,
  new_subscribers integer,
  churned_subscribers integer,
  subscriber_churn_mtd numeric,
  active_start_mtd integer,
  new_mtd integer,
  churned_mtd integer,
  voluntary_churn_mtd integer,
  involuntary_churn_mtd integer,
  unknown_churn_mtd integer,
  scheduled_cancellations integer,
  payment_failures_30d integer,
  first_renewals_30d integer,
  mrr_at_risk numeric,
  mrr_churned_mtd numeric,
  mrr_active numeric,
  monthly_share numeric,
  annual_share numeric,
  behavioral_available boolean NOT NULL DEFAULT false,
  red_count integer,
  yellow_count integer,
  green_count integer,
  sem_uso_20_44d integer,
  sem_uso_90d_mais integer,
  fonte text NOT NULL DEFAULT 'RECONSTRUIDO'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.intervention_experiments (
  experiment_id bigint NOT NULL,
  signal_code text NOT NULL,
  diagnosis_code text,
  target_population text,
  sample_size integer,
  intervention_type text,
  channel text,
  copy_version text,
  owner text,
  start_date date,
  end_date date,
  expected_outcome text,
  outcome_window integer,
  result text,
  decision text,
  evidence_level text,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.intervention_outcomes (
  id bigint NOT NULL,
  source text NOT NULL DEFAULT 'MONDAY_COCKPIT'::text,
  external_id text,
  email text,
  customer_id text,
  subscription_id text,
  signal_id bigint,
  fila text,
  intervention_type text,
  channel text,
  copy_version text,
  first_touch_at date,
  responded boolean,
  outcome text,
  outcome_normalizado text,
  outcome_at date,
  plan_type text,
  health_score_label text,
  valor numeric,
  raw jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.intervention_recommendations (
  recommendation_id bigint NOT NULL,
  signal_id bigint NOT NULL,
  customer_id text,
  subscription_id text,
  recommendation_date date NOT NULL DEFAULT CURRENT_DATE,
  strategy_code text NOT NULL,
  intervention_type text NOT NULL,
  channel text,
  recommended_action text NOT NULL,
  recommended_timing text,
  why_customer text,
  why_strategy text,
  why_now text,
  why_intervention text,
  why_priority text,
  reason text,
  evidence_level text NOT NULL,
  historical_peer_count integer DEFAULT 0,
  historical_outcome_count integer DEFAULT 0,
  peer_basis text,
  objetivo text,
  mensagem_principal text,
  argumento text,
  cta text,
  evitar text,
  automation_id text,
  automation_gap text,
  priority_score numeric,
  priority_rank integer,
  status text NOT NULL DEFAULT 'PENDING'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.invoice_backfill_runs (
  id bigint NOT NULL,
  periodo_inicio timestamp with time zone NOT NULL,
  periodo_fim timestamp with time zone NOT NULL,
  invoices_api integer,
  invoices_novas integer,
  status text NOT NULL DEFAULT 'running'::text,
  erro text,
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone
);

CREATE TABLE public.kpi_snapshots (
  id bigint NOT NULL,
  kpi_code text NOT NULL,
  kpi_name text NOT NULL,
  period date NOT NULL,
  value numeric,
  source text NOT NULL,
  is_official boolean NOT NULL DEFAULT false,
  detail jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.learning_events (
  id bigint NOT NULL,
  learned_at date NOT NULL DEFAULT CURRENT_DATE,
  scope text NOT NULL,
  subject text NOT NULL,
  finding text NOT NULL,
  evidence_level text NOT NULL,
  sample_size integer,
  detail jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.machine_queue (
  id bigint NOT NULL,
  queue_date date NOT NULL DEFAULT CURRENT_DATE,
  item_code text NOT NULL,
  titulo text NOT NULL,
  sistema text,
  automacao text,
  problema text NOT NULL,
  populacao_afetada integer,
  impacto_mrr numeric,
  impacto_descricao text,
  acao_recomendada text,
  gap_type text,
  evidencia jsonb,
  prioridade numeric,
  status text NOT NULL DEFAULT 'OPEN'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.signal_context (
  signal_id bigint NOT NULL,
  contact_id text,
  snapshot_date date,
  subscription_id text,
  segmento text,
  health_score_label text,
  categoria_dominante text,
  produto_assinado text,
  tipo_plano text,
  tipo_pagamento text,
  criterio_ativacao text,
  cliente_reativado text,
  reativacoes numeric,
  cliente_desde date,
  data_renovacao date,
  dias_sem_acesso numeric,
  topicos_iniciados_60d numeric,
  topicos_unicos_60d numeric,
  sessoes_semana numeric,
  conteudos_consumidos numeric,
  ultimo_acesso date,
  momento_carreira text,
  estado_uf text,
  ambiente_atuacao text,
  especialidade text,
  plan_amount numeric,
  mrr numeric,
  cobrancas_pagas integer,
  tenure_dias integer,
  cobertura jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.signals (
  signal_id bigint NOT NULL,
  signal_code text NOT NULL,
  customer_id text,
  subscription_id text,
  detected_at timestamp with time zone NOT NULL DEFAULT now(),
  detection_date date NOT NULL DEFAULT CURRENT_DATE,
  signal_type text,
  signal_owner text NOT NULL,
  signal_confidence text NOT NULL,
  severity text,
  context jsonb,
  diagnosis_code text,
  strategy_code text,
  intervention_strategy text,
  journey_expected text,
  journey_actual text,
  action_taken text,
  action_at timestamp with time zone,
  outcome text,
  outcome_at timestamp with time zone,
  mrr_at_risk numeric,
  mrr_preserved numeric,
  evidence jsonb,
  churn_type text,
  time_to_churn integer,
  remaining_action_window integer,
  recoverability text,
  status text NOT NULL DEFAULT 'OPEN'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.stripe_customers (
  id text NOT NULL,
  email text,
  phone text,
  name text,
  created timestamp with time zone,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE public.stripe_events_log (
  id bigint NOT NULL,
  object_id text NOT NULL,
  object_type text NOT NULL,
  field_changed text,
  old_value text,
  new_value text,
  detected_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.stripe_invoice_events_log (
  id bigint NOT NULL,
  invoice_id text NOT NULL,
  field_changed text NOT NULL,
  old_value text,
  new_value text,
  detected_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.stripe_invoices (
  id text NOT NULL,
  subscription_id text,
  customer_id text,
  status text,
  amount_paid numeric,
  amount_due numeric,
  billing_reason text,
  created timestamp with time zone,
  paid_at timestamp with time zone,
  updated_at timestamp with time zone DEFAULT now(),
  paid boolean,
  currency text,
  amount numeric,
  period_start timestamp with time zone,
  period_end timestamp with time zone,
  subscription_id_raw text,
  customer_id_raw text,
  auto_advance boolean,
  attempted boolean,
  attempt_count integer,
  next_payment_attempt timestamp with time zone,
  due_date timestamp with time zone,
  finalized_at timestamp with time zone,
  billing_state_at timestamp with time zone
);

CREATE TABLE public.stripe_subscriptions (
  id text NOT NULL,
  customer_id text NOT NULL,
  status text NOT NULL,
  plan_interval text,
  plan_amount numeric,
  plan_nickname text,
  metadata_includes_questions boolean,
  metadata_commitment_months integer,
  created timestamp with time zone,
  current_period_start timestamp with time zone,
  current_period_end timestamp with time zone,
  cancel_at_period_end boolean DEFAULT false,
  canceled_at timestamp with time zone,
  cancellation_reason text,
  cancellation_feedback text,
  updated_at timestamp with time zone DEFAULT now(),
  trial_start timestamp with time zone,
  trial_end timestamp with time zone,
  start_date timestamp with time zone,
  currency text
);

CREATE TABLE public.sync_checkpoints (
  id bigint NOT NULL,
  script text NOT NULL,
  modo text NOT NULL,
  referencia timestamp with time zone,
  status text NOT NULL DEFAULT 'aberta'::text,
  ultimo_id bigint NOT NULL DEFAULT 0,
  paginas integer NOT NULL DEFAULT 0,
  contatos_lidos integer NOT NULL DEFAULT 0,
  run_ids bigint[] NOT NULL DEFAULT '{}'::bigint[],
  iniciado_em timestamp with time zone NOT NULL DEFAULT now(),
  atualizado_em timestamp with time zone NOT NULL DEFAULT now(),
  concluido_em timestamp with time zone
);

CREATE TABLE public.sync_runs (
  id bigint NOT NULL,
  script text NOT NULL,
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  finished_at timestamp with time zone,
  status text NOT NULL DEFAULT 'running'::text,
  registros jsonb,
  erro text
);

CREATE TABLE public.tdcos_user_audit (
  id bigint NOT NULL,
  ocorrido_em timestamp with time zone NOT NULL DEFAULT now(),
  ator_user_id uuid,
  ator_email text,
  alvo_user_id uuid,
  alvo_email text,
  acao text NOT NULL,
  papel_antes text,
  papel_depois text,
  detalhe jsonb
);

CREATE TABLE public.tdcos_users (
  user_id uuid NOT NULL,
  email text NOT NULL,
  papel text NOT NULL,
  ativo boolean NOT NULL DEFAULT true,
  convidado_por uuid,
  convidado_em timestamp with time zone NOT NULL DEFAULT now(),
  ativado_em timestamp with time zone,
  suspenso_em timestamp with time zone,
  suspenso_por uuid,
  motivo_suspensao text,
  criado_em timestamp with time zone NOT NULL DEFAULT now(),
  atualizado_em timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.wf_ac_link (
  wf_code text NOT NULL,
  automation_id text NOT NULL,
  role text NOT NULL,
  confirmed_by text NOT NULL,
  confirmed_at timestamp with time zone NOT NULL,
  note text
);

CREATE TABLE public.wf_ac_snapshot (
  snapshot_date date NOT NULL,
  wf_code text NOT NULL,
  automation_id text NOT NULL,
  found boolean NOT NULL,
  ac_name text,
  status smallint,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  entered_count integer,
  exited_count integer,
  raw jsonb,
  source text NOT NULL,
  captured_at timestamp with time zone NOT NULL
);

CREATE TABLE public.wf_assessment (
  assessment_date date NOT NULL,
  wf_code text NOT NULL,
  automation_ids text[] NOT NULL,
  avaliada boolean NOT NULL,
  eligible_population integer,
  entered_population integer,
  cobertura numeric,
  execucao numeric,
  resultado numeric,
  churn_relacionado numeric,
  mrr numeric,
  diagnostico text,
  acao text,
  evidencia jsonb NOT NULL,
  assessed_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.wf_registry (
  wf_code text NOT NULL,
  wf_number text NOT NULL,
  wf_name text NOT NULL,
  display_order smallint NOT NULL,
  signal_codes text[],
  created_at timestamp with time zone NOT NULL DEFAULT now()
);


-- ----------------------------------------------------------------------------
-- 2. CONSTRAINTS (primary keys, unique, checks, foreign keys)
-- ----------------------------------------------------------------------------

ALTER TABLE public.ac_automation_contacts ADD CONSTRAINT ac_automation_contacts_pkey PRIMARY KEY (contact_automation_id);
ALTER TABLE public.ac_contact_tags ADD CONSTRAINT ac_contact_tags_pkey PRIMARY KEY (contact_id, tag_id, applied_at);
ALTER TABLE public.ac_contacts ADD CONSTRAINT ac_contacts_pkey PRIMARY KEY (id);
ALTER TABLE public.ac_field_values ADD CONSTRAINT ac_field_values_pkey PRIMARY KEY (contact_id, field_id);
ALTER TABLE public.automation_assessment ADD CONSTRAINT automation_assessment_pkey PRIMARY KEY (id);
ALTER TABLE public.customer_daily_snapshot ADD CONSTRAINT customer_daily_snapshot_pkey PRIMARY KEY (id);
ALTER TABLE public.customer_identity ADD CONSTRAINT customer_identity_pkey PRIMARY KEY (id);
ALTER TABLE public.customer_queue ADD CONSTRAINT customer_queue_pkey PRIMARY KEY (id);
ALTER TABLE public.forecast_outcomes ADD CONSTRAINT forecast_outcomes_pkey PRIMARY KEY (id);
ALTER TABLE public.forecast_runs ADD CONSTRAINT forecast_runs_pkey PRIMARY KEY (forecast_id);
ALTER TABLE public.historical_snapshots ADD CONSTRAINT historical_snapshots_pkey PRIMARY KEY (snapshot_date);
ALTER TABLE public.intervention_experiments ADD CONSTRAINT intervention_experiments_pkey PRIMARY KEY (experiment_id);
ALTER TABLE public.intervention_outcomes ADD CONSTRAINT intervention_outcomes_pkey PRIMARY KEY (id);
ALTER TABLE public.intervention_recommendations ADD CONSTRAINT intervention_recommendations_pkey PRIMARY KEY (recommendation_id);
ALTER TABLE public.invoice_backfill_runs ADD CONSTRAINT invoice_backfill_runs_pkey PRIMARY KEY (id);
ALTER TABLE public.kpi_snapshots ADD CONSTRAINT kpi_snapshots_pkey PRIMARY KEY (id);
ALTER TABLE public.learning_events ADD CONSTRAINT learning_events_pkey PRIMARY KEY (id);
ALTER TABLE public.machine_queue ADD CONSTRAINT machine_queue_pkey PRIMARY KEY (id);
ALTER TABLE public.signal_context ADD CONSTRAINT signal_context_pkey PRIMARY KEY (signal_id);
ALTER TABLE public.signals ADD CONSTRAINT signals_pkey PRIMARY KEY (signal_id);
ALTER TABLE public.stripe_customers ADD CONSTRAINT stripe_customers_pkey PRIMARY KEY (id);
ALTER TABLE public.stripe_events_log ADD CONSTRAINT stripe_events_log_pkey PRIMARY KEY (id);
ALTER TABLE public.stripe_invoice_events_log ADD CONSTRAINT stripe_invoice_events_log_pkey PRIMARY KEY (id);
ALTER TABLE public.stripe_invoices ADD CONSTRAINT stripe_invoices_pkey PRIMARY KEY (id);
ALTER TABLE public.stripe_subscriptions ADD CONSTRAINT stripe_subscriptions_pkey PRIMARY KEY (id);
ALTER TABLE public.sync_checkpoints ADD CONSTRAINT sync_checkpoints_pkey PRIMARY KEY (id);
ALTER TABLE public.sync_runs ADD CONSTRAINT sync_runs_pkey PRIMARY KEY (id);
ALTER TABLE public.tdcos_user_audit ADD CONSTRAINT tdcos_user_audit_pkey PRIMARY KEY (id);
ALTER TABLE public.tdcos_users ADD CONSTRAINT tdcos_users_pkey PRIMARY KEY (user_id);
ALTER TABLE public.wf_ac_link ADD CONSTRAINT wf_ac_link_pkey PRIMARY KEY (wf_code, automation_id);
ALTER TABLE public.wf_ac_snapshot ADD CONSTRAINT wf_ac_snapshot_pkey PRIMARY KEY (snapshot_date, wf_code, automation_id);
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_pkey PRIMARY KEY (assessment_date, wf_code);
ALTER TABLE public.wf_registry ADD CONSTRAINT wf_registry_pkey PRIMARY KEY (wf_code);
ALTER TABLE public.wf_ac_link ADD CONSTRAINT wf_ac_link_automation_id_key UNIQUE (automation_id);
ALTER TABLE public.wf_registry ADD CONSTRAINT wf_registry_display_order_key UNIQUE (display_order);
ALTER TABLE public.customer_identity ADD CONSTRAINT chk_identity_status CHECK ((identity_match_status = ANY (ARRAY['MATCHED'::text, 'AMBIGUOUS'::text, 'UNMATCHED'::text])));
ALTER TABLE public.sync_checkpoints ADD CONSTRAINT sync_checkpoints_check CHECK (((modo = 'completo'::text) OR (referencia IS NOT NULL)));
ALTER TABLE public.sync_checkpoints ADD CONSTRAINT sync_checkpoints_check1 CHECK (((status = 'concluida'::text) = (concluido_em IS NOT NULL)));
ALTER TABLE public.sync_checkpoints ADD CONSTRAINT sync_checkpoints_modo_check CHECK ((modo = ANY (ARRAY['completo'::text, 'incremental'::text])));
ALTER TABLE public.sync_checkpoints ADD CONSTRAINT sync_checkpoints_status_check CHECK ((status = ANY (ARRAY['aberta'::text, 'concluida'::text, 'substituida'::text])));
ALTER TABLE public.tdcos_users ADD CONSTRAINT tdcos_users_papel_check CHECK ((papel = ANY (ARRAY['ADMIN'::text, 'STAFF'::text])));
ALTER TABLE public.wf_ac_link ADD CONSTRAINT wf_ac_link_role_check CHECK ((role = ANY (ARRAY['principal'::text, 'variante'::text, 'historica'::text])));
ALTER TABLE public.wf_ac_snapshot ADD CONSTRAINT wf_ac_snapshot_check CHECK ((found OR ((ac_name IS NULL) AND (status IS NULL) AND (entered_count IS NULL) AND (exited_count IS NULL) AND (raw IS NULL))));
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_acao_check CHECK ((acao = ANY (ARRAY['FIX_TRIGGER'::text, 'FIX_CRITERIA'::text, 'FIX_COVERAGE'::text, 'FIX_FLOW'::text, 'OPTIMIZE_TIMING'::text, 'OPTIMIZE_COPY'::text, 'OPTIMIZE_CHANNEL'::text, 'REASSESS_STRATEGY'::text])));
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_check CHECK ((avaliada OR ((eligible_population IS NULL) AND (entered_population IS NULL) AND (cobertura IS NULL) AND (execucao IS NULL) AND (resultado IS NULL) AND (churn_relacionado IS NULL) AND (mrr IS NULL) AND (diagnostico IS NULL) AND (acao IS NULL))));
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_check1 CHECK (((wf_code <> 'WF-05'::text) OR (acao IS NULL)));
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_check2 CHECK (((acao IS NULL) OR (diagnostico IS NOT NULL)));
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_diagnostico_check CHECK ((diagnostico = ANY (ARRAY['STRATEGY_GAP'::text, 'EXECUTION_GAP'::text, 'AUTOMATION_GAP'::text, 'DATA_GAP'::text, 'HYPOTHESIS_GAP'::text])));
ALTER TABLE public.ac_automation_contacts ADD CONSTRAINT ac_automation_contacts_automation_id_fkey FOREIGN KEY (automation_id) REFERENCES wf_ac_link(automation_id);
ALTER TABLE public.ac_contact_tags ADD CONSTRAINT ac_contact_tags_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES ac_contacts(id);
ALTER TABLE public.ac_field_values ADD CONSTRAINT ac_field_values_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES ac_contacts(id);
ALTER TABLE public.customer_daily_snapshot ADD CONSTRAINT customer_daily_snapshot_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES ac_contacts(id);
ALTER TABLE public.customer_daily_snapshot ADD CONSTRAINT customer_daily_snapshot_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES stripe_subscriptions(id);
ALTER TABLE public.customer_identity ADD CONSTRAINT customer_identity_activecampaign_contact_id_fkey FOREIGN KEY (activecampaign_contact_id) REFERENCES ac_contacts(id);
ALTER TABLE public.customer_identity ADD CONSTRAINT customer_identity_stripe_customer_id_fkey FOREIGN KEY (stripe_customer_id) REFERENCES stripe_customers(id);
ALTER TABLE public.customer_queue ADD CONSTRAINT customer_queue_recommendation_id_fkey FOREIGN KEY (recommendation_id) REFERENCES intervention_recommendations(recommendation_id);
ALTER TABLE public.customer_queue ADD CONSTRAINT customer_queue_signal_id_fkey FOREIGN KEY (signal_id) REFERENCES signals(signal_id);
ALTER TABLE public.forecast_outcomes ADD CONSTRAINT forecast_outcomes_forecast_id_fkey FOREIGN KEY (forecast_id) REFERENCES forecast_runs(forecast_id) ON DELETE CASCADE;
ALTER TABLE public.intervention_outcomes ADD CONSTRAINT intervention_outcomes_signal_id_fkey FOREIGN KEY (signal_id) REFERENCES signals(signal_id);
ALTER TABLE public.intervention_recommendations ADD CONSTRAINT intervention_recommendations_signal_id_fkey FOREIGN KEY (signal_id) REFERENCES signals(signal_id) ON DELETE CASCADE;
ALTER TABLE public.signal_context ADD CONSTRAINT signal_context_signal_id_fkey FOREIGN KEY (signal_id) REFERENCES signals(signal_id) ON DELETE CASCADE;
ALTER TABLE public.stripe_invoice_events_log ADD CONSTRAINT stripe_invoice_events_log_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES stripe_invoices(id);
ALTER TABLE public.stripe_invoices ADD CONSTRAINT stripe_invoices_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES stripe_customers(id);
ALTER TABLE public.stripe_invoices ADD CONSTRAINT stripe_invoices_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES stripe_subscriptions(id);
ALTER TABLE public.stripe_subscriptions ADD CONSTRAINT stripe_subscriptions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES stripe_customers(id);
ALTER TABLE public.tdcos_users ADD CONSTRAINT tdcos_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.wf_ac_link ADD CONSTRAINT wf_ac_link_wf_code_fkey FOREIGN KEY (wf_code) REFERENCES wf_registry(wf_code);
ALTER TABLE public.wf_ac_snapshot ADD CONSTRAINT wf_ac_snapshot_wf_code_automation_id_fkey FOREIGN KEY (wf_code, automation_id) REFERENCES wf_ac_link(wf_code, automation_id);
ALTER TABLE public.wf_assessment ADD CONSTRAINT wf_assessment_wf_code_fkey FOREIGN KEY (wf_code) REFERENCES wf_registry(wf_code);


-- ----------------------------------------------------------------------------
-- 3. INDEXES
-- ----------------------------------------------------------------------------

CREATE INDEX ac_automation_contacts_auto_entrada ON public.ac_automation_contacts USING btree (automation_id, entered_at);
CREATE INDEX ac_automation_contacts_contato ON public.ac_automation_contacts USING btree (contact_id);
CREATE INDEX idx_tags_contact ON public.ac_contact_tags USING btree (contact_id);
CREATE INDEX idx_tags_name ON public.ac_contact_tags USING btree (tag_name);
CREATE INDEX idx_ac_contacts_email ON public.ac_contacts USING btree (email);
CREATE INDEX idx_fieldvalues_field ON public.ac_field_values USING btree (field_id);
CREATE UNIQUE INDEX uq_assessment ON public.automation_assessment USING btree (assessment_date, signal_code);
CREATE INDEX idx_snapshot_contact ON public.customer_daily_snapshot USING btree (contact_id);
CREATE INDEX idx_snapshot_date ON public.customer_daily_snapshot USING btree (snapshot_date);
CREATE UNIQUE INDEX uq_snapshot_dia ON public.customer_daily_snapshot USING btree (snapshot_date, COALESCE(contact_id, ''::text), COALESCE(subscription_id, ''::text));
CREATE INDEX idx_identity_ac ON public.customer_identity USING btree (activecampaign_contact_id);
CREATE INDEX idx_identity_email ON public.customer_identity USING btree (email);
CREATE INDEX idx_identity_status ON public.customer_identity USING btree (identity_match_status);
CREATE INDEX idx_identity_stripe ON public.customer_identity USING btree (stripe_customer_id);
CREATE UNIQUE INDEX uq_identity_par ON public.customer_identity USING btree (email, COALESCE(stripe_customer_id, ''::text), COALESCE(activecampaign_contact_id, ''::text));
CREATE INDEX idx_cqueue_rank ON public.customer_queue USING btree (queue_date, rank);
CREATE UNIQUE INDEX uq_cqueue ON public.customer_queue USING btree (queue_date, COALESCE(subscription_id, ''::text), signal_code);
CREATE INDEX idx_fo_horizonte ON public.forecast_outcomes USING btree (days_before_close, metric);
CREATE INDEX idx_fo_month ON public.forecast_outcomes USING btree (target_month);
CREATE INDEX idx_forecast_month ON public.forecast_runs USING btree (target_month);
CREATE UNIQUE INDEX uq_forecast ON public.forecast_runs USING btree (forecast_date, target_month, method, model_version);
CREATE INDEX idx_hist_month ON public.historical_snapshots USING btree (month);
CREATE INDEX idx_outcome_norm ON public.intervention_outcomes USING btree (outcome_normalizado);
CREATE UNIQUE INDEX uq_outcome_ext ON public.intervention_outcomes USING btree (source, external_id);
CREATE INDEX idx_rec_prio ON public.intervention_recommendations USING btree (recommendation_date, priority_rank);
CREATE INDEX idx_rec_signal ON public.intervention_recommendations USING btree (signal_id);
CREATE INDEX idx_backfill_periodo ON public.invoice_backfill_runs USING btree (periodo_inicio, periodo_fim, status);
CREATE INDEX idx_kpi_period ON public.kpi_snapshots USING btree (period DESC);
CREATE UNIQUE INDEX uq_kpi_snapshot ON public.kpi_snapshots USING btree (kpi_code, period, source);
CREATE INDEX idx_learning ON public.learning_events USING btree (scope, learned_at DESC);
CREATE UNIQUE INDEX uq_mqueue ON public.machine_queue USING btree (queue_date, item_code);
CREATE INDEX idx_sigctx_contact ON public.signal_context USING btree (contact_id);
CREATE INDEX idx_signals_code ON public.signals USING btree (signal_code, detection_date DESC);
CREATE INDEX idx_signals_cust ON public.signals USING btree (customer_id);
CREATE INDEX idx_signals_status ON public.signals USING btree (status);
CREATE UNIQUE INDEX uq_signal_dia ON public.signals USING btree (signal_code, COALESCE(subscription_id, ''::text), detection_date);
CREATE INDEX idx_customers_email ON public.stripe_customers USING btree (email);
CREATE INDEX idx_events_detected ON public.stripe_events_log USING btree (detected_at);
CREATE INDEX idx_events_object ON public.stripe_events_log USING btree (object_id);
CREATE INDEX idx_inv_events_detected ON public.stripe_invoice_events_log USING btree (detected_at);
CREATE INDEX idx_inv_events_invoice ON public.stripe_invoice_events_log USING btree (invoice_id);
CREATE INDEX idx_inv_auto_advance ON public.stripe_invoices USING btree (auto_advance) WHERE (auto_advance IS NOT NULL);
CREATE INDEX idx_invoices_created ON public.stripe_invoices USING btree (created);
CREATE INDEX idx_invoices_cust_raw ON public.stripe_invoices USING btree (customer_id_raw);
CREATE INDEX idx_invoices_paid_at ON public.stripe_invoices USING btree (paid_at);
CREATE INDEX idx_invoices_status ON public.stripe_invoices USING btree (status);
CREATE INDEX idx_invoices_sub ON public.stripe_invoices USING btree (subscription_id);
CREATE INDEX idx_invoices_sub_raw ON public.stripe_invoices USING btree (subscription_id_raw);
CREATE INDEX idx_subs_canceled ON public.stripe_subscriptions USING btree (canceled_at);
CREATE INDEX idx_subs_created ON public.stripe_subscriptions USING btree (created);
CREATE INDEX idx_subs_customer ON public.stripe_subscriptions USING btree (customer_id);
CREATE INDEX idx_subs_status ON public.stripe_subscriptions USING btree (status);
CREATE INDEX idx_subs_trial_end ON public.stripe_subscriptions USING btree (trial_end);
CREATE UNIQUE INDEX sync_checkpoints_uma_aberta ON public.sync_checkpoints USING btree (script) WHERE (status = 'aberta'::text);
CREATE INDEX idx_sync_runs_script ON public.sync_runs USING btree (script, started_at DESC);
CREATE INDEX idx_user_audit ON public.tdcos_user_audit USING btree (ocorrido_em DESC);
CREATE INDEX idx_tdcos_users_ativo ON public.tdcos_users USING btree (ativo, papel);
CREATE UNIQUE INDEX uq_tdcos_users_email ON public.tdcos_users USING btree (lower(email));


-- ----------------------------------------------------------------------------
-- 4. VIEWS (part 1: everything the functions depend on)
-- ----------------------------------------------------------------------------

CREATE OR REPLACE VIEW public.v_customer_360 AS
 SELECT c.id AS contact_id,
    c.email,
    c.phone,
    c.firstname,
    c.lastname,
    hs.value AS health_score,
    hs_label.value AS health_score_label,
    cat.value AS categoria_dominante,
    mc.value AS momento_carreira,
    seg.value AS segmento
   FROM ac_contacts c
     LEFT JOIN ac_field_values hs ON hs.contact_id = c.id AND hs.field_id = '19'::text
     LEFT JOIN ac_field_values hs_label ON hs_label.contact_id = c.id AND hs_label.field_id = '20'::text
     LEFT JOIN ac_field_values cat ON cat.contact_id = c.id AND cat.field_id = '15'::text
     LEFT JOIN ac_field_values mc ON mc.contact_id = c.id AND mc.field_id = '47'::text
     LEFT JOIN ac_field_values seg ON seg.contact_id = c.id AND seg.field_id = '55'::text;

CREATE OR REPLACE VIEW public.v_subscription_360 AS
 SELECT cu.contact_id,
    cu.email,
    cu.phone,
    cu.health_score,
    cu.health_score_label,
    cu.categoria_dominante,
    cu.momento_carreira,
    cu.segmento,
    s.id AS subscription_id,
    s.status AS stripe_status,
    s.plan_interval,
    s.plan_amount,
    s.cancel_at_period_end,
    s.canceled_at,
    s.current_period_start,
    s.current_period_end,
    s.metadata_includes_questions,
    s.created AS subscription_created
   FROM v_customer_360 cu
     JOIN customer_identity ci ON ci.activecampaign_contact_id = cu.contact_id AND ci.identity_match_status = 'MATCHED'::text
     JOIN stripe_subscriptions s ON s.customer_id = ci.stripe_customer_id;

CREATE OR REPLACE VIEW public.v_tag_ativado_ultima AS
 SELECT contact_id,
    max(applied_at) AS ativado_em
   FROM ac_contact_tags
  WHERE tag_name = 'Ativado'::text AND removed_at IS NULL
  GROUP BY contact_id;

CREATE OR REPLACE VIEW public.v_recuperacoes_semana AS
 SELECT i.id AS invoice_id,
    s.customer_id,
    c.email,
    s.plan_interval,
    i.amount_paid / 100.0 AS valor_recuperado,
    i.paid_at,
    ev.detected_at
   FROM stripe_invoice_events_log ev
     JOIN stripe_invoices i ON i.id = ev.invoice_id
     JOIN stripe_subscriptions s ON s.id = i.subscription_id
     JOIN stripe_customers c ON c.id = s.customer_id
  WHERE ev.field_changed = 'status'::text AND ev.new_value = 'paid'::text AND (i.billing_reason = ANY (ARRAY['subscription_cycle'::text, 'manual'::text]));

CREATE OR REPLACE VIEW public.v_candidatos_upsell_questoes AS
 SELECT v.contact_id,
    v.email,
    v.phone,
    v.health_score,
    v.health_score_label,
    v.categoria_dominante,
    v.momento_carreira,
    v.segmento,
    v.subscription_id,
    v.stripe_status,
    v.plan_interval,
    v.plan_amount,
    v.cancel_at_period_end,
    v.canceled_at,
    v.current_period_start,
    v.current_period_end,
    v.metadata_includes_questions,
    v.subscription_created,
    t.ativado_em,
    EXTRACT(epoch FROM now() - t.ativado_em) / 86400::numeric AS dias_desde_ativacao
   FROM v_subscription_360 v
     JOIN v_tag_ativado_ultima t ON t.contact_id = v.contact_id
  WHERE v.stripe_status = 'active'::text AND v.metadata_includes_questions IS NOT TRUE AND v.phone IS NOT NULL AND v.phone <> ''::text AND (EXTRACT(epoch FROM now() - t.ativado_em) / 86400::numeric) >= 30::numeric;

CREATE OR REPLACE VIEW public.v_candidatos_upsell_anual AS
 SELECT contact_id,
    email,
    phone,
    health_score,
    health_score_label,
    categoria_dominante,
    momento_carreira,
    segmento,
    subscription_id,
    stripe_status,
    plan_interval,
    plan_amount,
    cancel_at_period_end,
    canceled_at,
    current_period_start,
    current_period_end,
    metadata_includes_questions,
    subscription_created,
    EXTRACT(epoch FROM now() - subscription_created) / 86400::numeric AS dias_de_assinatura
   FROM v_subscription_360 v
  WHERE stripe_status = 'active'::text AND plan_interval = 'month'::text AND health_score_label = 'verde'::text AND phone IS NOT NULL AND phone <> ''::text AND (EXTRACT(epoch FROM now() - subscription_created) / 86400::numeric) >= 305::numeric AND (EXTRACT(epoch FROM now() - subscription_created) / 86400::numeric) <= 365::numeric;

CREATE OR REPLACE VIEW public.v_invoice_evidence AS
 SELECT COALESCE(subscription_id, subscription_id_raw) AS subscription_id,
    count(*) AS invoice_count,
    min(created) AS first_invoice_date,
    max(created) AS last_invoice_date,
    count(*) FILTER (WHERE status = 'paid'::text AND amount_paid > 0::numeric) AS paid_invoice_count,
    min(COALESCE(paid_at, created)) FILTER (WHERE status = 'paid'::text AND amount_paid > 0::numeric) AS first_paid_invoice_date,
    max(COALESCE(paid_at, created)) FILTER (WHERE status = 'paid'::text AND amount_paid > 0::numeric) AS last_paid_invoice_date,
    COALESCE(sum(amount_paid) FILTER (WHERE status = 'paid'::text AND amount_paid > 0::numeric), 0::numeric) / 100.0 AS total_paid,
    count(*) FILTER (WHERE status = 'paid'::text AND COALESCE(amount_paid, 0::numeric) = 0::numeric) AS zero_value_paid_count,
    count(*) FILTER (WHERE status = ANY (ARRAY['open'::text, 'draft'::text])) AS open_invoice_count,
    count(*) FILTER (WHERE status = 'uncollectible'::text) AS uncollectible_count,
    count(*) FILTER (WHERE status = 'void'::text) AS void_count
   FROM stripe_invoices
  WHERE COALESCE(subscription_id, subscription_id_raw) IS NOT NULL
  GROUP BY (COALESCE(subscription_id, subscription_id_raw));

CREATE OR REPLACE VIEW public.v_identity_by_customer AS
 SELECT stripe_customer_id,
    min(email) AS email,
        CASE
            WHEN bool_or(identity_match_status = 'AMBIGUOUS'::text) THEN 'AMBIGUOUS'::text
            WHEN bool_or(identity_match_status = 'MATCHED'::text) THEN 'MATCHED'::text
            ELSE 'UNMATCHED'::text
        END AS identity_match_status,
        CASE
            WHEN bool_or(identity_match_status = 'AMBIGUOUS'::text) THEN NULL::text
            WHEN count(DISTINCT activecampaign_contact_id) FILTER (WHERE identity_match_status = 'MATCHED'::text) = 1 THEN max(activecampaign_contact_id) FILTER (WHERE identity_match_status = 'MATCHED'::text)
            ELSE NULL::text
        END AS ac_contact_id
   FROM customer_identity
  WHERE stripe_customer_id IS NOT NULL
  GROUP BY stripe_customer_id;

CREATE OR REPLACE VIEW public.v_contact_behavior AS
 SELECT c.id AS contact_id,
    c.email,
    c.phone,
    hs.value AS health_score,
    hsl.value AS health_score_label,
    seg.value AS segment,
    cat.value AS categoria_dominante,
    mom.value AS momento_carreira,
        CASE
            WHEN t52.value ~ '^-?[0-9]+(\.[0-9]+)?$'::text THEN t52.value::numeric
            ELSE NULL::numeric
        END AS topics_started_60d,
        CASE
            WHEN t53.value ~ '^-?[0-9]+(\.[0-9]+)?$'::text THEN t53.value::numeric
            ELSE NULL::numeric
        END AS topics_unique_visited_60d,
        CASE
            WHEN t14.value ~ '^-?[0-9]+(\.[0-9]+)?$'::text THEN t14.value::numeric
            ELSE NULL::numeric
        END AS topics_completed_60d,
        CASE
            WHEN d21.value ~ '^-?[0-9]+(\.[0-9]+)?$'::text THEN d21.value::numeric
            ELSE NULL::numeric
        END AS days_since_last_use,
        CASE
            WHEN s16.value ~ '^-?[0-9]+(\.[0-9]+)?$'::text THEN s16.value::numeric
            ELSE NULL::numeric
        END AS sessions_7d,
    NULLIF(btrim(ativ.value, '|'::text), ''::text) AS activation_status,
    NULL::text AS risk_level
   FROM ac_contacts c
     LEFT JOIN ac_field_values hs ON hs.contact_id = c.id AND hs.field_id = '19'::text
     LEFT JOIN ac_field_values hsl ON hsl.contact_id = c.id AND hsl.field_id = '20'::text
     LEFT JOIN ac_field_values seg ON seg.contact_id = c.id AND seg.field_id = '55'::text
     LEFT JOIN ac_field_values cat ON cat.contact_id = c.id AND cat.field_id = '15'::text
     LEFT JOIN ac_field_values mom ON mom.contact_id = c.id AND mom.field_id = '47'::text
     LEFT JOIN ac_field_values t52 ON t52.contact_id = c.id AND t52.field_id = '52'::text
     LEFT JOIN ac_field_values t53 ON t53.contact_id = c.id AND t53.field_id = '53'::text
     LEFT JOIN ac_field_values t14 ON t14.contact_id = c.id AND t14.field_id = '14'::text
     LEFT JOIN ac_field_values d21 ON d21.contact_id = c.id AND d21.field_id = '21'::text
     LEFT JOIN ac_field_values s16 ON s16.contact_id = c.id AND s16.field_id = '16'::text
     LEFT JOIN ac_field_values ativ ON ativ.contact_id = c.id AND ativ.field_id = '25'::text;

CREATE OR REPLACE VIEW public.v_subscription_financial_status AS
 SELECT s.id AS subscription_id,
    s.customer_id,
    s.created AS subscription_created,
    s.canceled_at,
    s.status AS subscription_status,
    s.trial_start,
    s.trial_end,
    e.first_invoice_date,
    e.first_paid_invoice_date,
    e.last_paid_invoice_date,
    COALESCE(e.paid_invoice_count, 0::bigint) AS paid_invoice_count,
    COALESCE(e.total_paid, 0::numeric) AS total_paid,
    COALESCE(e.invoice_count, 0::bigint) AS invoice_count,
    COALESCE(e.zero_value_paid_count, 0::bigint) AS zero_value_paid_count,
    COALESCE(e.open_invoice_count, 0::bigint) AS open_invoice_count,
    COALESCE(e.uncollectible_count, 0::bigint) AS uncollectible_count,
    COALESCE(e.void_count, 0::bigint) AS void_count,
    COALESCE(e.paid_invoice_count, 0::bigint) > 0 AS has_paid_invoice,
    COALESCE(e.invoice_count, 0::bigint) > 0 AS has_any_invoice,
        CASE
            WHEN COALESCE(e.paid_invoice_count, 0::bigint) > 0 THEN 'PAGANTE_CONFIRMADO'::text
            WHEN COALESCE(e.paid_invoice_count, 0::bigint) = 0 AND s.trial_end IS NOT NULL AND s.canceled_at IS NOT NULL AND s.canceled_at <= s.trial_end THEN 'TRIAL_CONFIRMADO'::text
            ELSE 'INDETERMINADO'::text
        END AS financial_classification,
        CASE
            WHEN COALESCE(e.paid_invoice_count, 0::bigint) > 0 THEN 'COBRANCA_PAGA_COM_VALOR_MAIOR_QUE_ZERO'::text
            WHEN s.trial_end IS NOT NULL AND s.canceled_at IS NOT NULL AND s.canceled_at <= s.trial_end THEN 'CANCELOU_DENTRO_DO_TRIAL_SEM_COBRANCA_PAGA'::text
            WHEN s.status = 'trialing'::text AND s.canceled_at IS NULL THEN 'EM_TRIAL_AINDA_SEM_DESFECHO'::text
            WHEN s.trial_end IS NOT NULL AND s.canceled_at IS NOT NULL AND s.canceled_at > s.trial_end THEN 'PASSOU_DO_TRIAL_MAS_NAO_HA_COBRANCA_PAGA'::text
            WHEN COALESCE(e.invoice_count, 0::bigint) = 0 THEN 'NENHUMA_COBRANCA_ENCONTRADA_NO_STRIPE'::text
            WHEN COALESCE(e.zero_value_paid_count, 0::bigint) > 0 THEN 'SO_COBRANCAS_DE_VALOR_ZERO'::text
            WHEN COALESCE(e.open_invoice_count, 0::bigint) > 0 THEN 'COBRANCA_EMITIDA_MAS_NAO_PAGA'::text
            ELSE 'SEM_EVIDENCIA_SUFICIENTE'::text
        END AS classification_reason
   FROM stripe_subscriptions s
     LEFT JOIN v_invoice_evidence e ON e.subscription_id = s.id;

CREATE OR REPLACE VIEW public.v_churn_events AS
 SELECT f.subscription_id,
    f.customer_id,
    i.email,
    f.subscription_created,
    f.canceled_at,
    round(EXTRACT(epoch FROM f.canceled_at - f.subscription_created) / 86400.0)::integer AS tenure_days,
    f.trial_start,
    f.trial_end,
    f.financial_classification,
    f.classification_reason,
        CASE f.financial_classification
            WHEN 'TRIAL_CONFIRMADO'::text THEN 'TRIAL_CANCELLATION'::text
            WHEN 'PAGANTE_CONFIRMADO'::text THEN 'PAID_CUSTOMER_CHURN'::text
            ELSE 'INDETERMINED_CANCELLATION'::text
        END AS churn_classification,
    s.plan_amount / 100.0 AS plan_amount,
    s.plan_interval,
    s.plan_nickname AS plan_name,
    s.cancellation_reason,
    s.cancellation_feedback,
    f.first_paid_invoice_date,
    f.last_paid_invoice_date,
    f.paid_invoice_count,
    f.total_paid,
    f.invoice_count,
    f.open_invoice_count,
    f.uncollectible_count,
    f.zero_value_paid_count,
    b.segment,
    b.health_score,
    b.health_score_label,
    b.days_since_last_use,
    b.topics_started_60d,
    b.topics_unique_visited_60d,
    b.sessions_7d,
    b.activation_status,
    COALESCE(i.identity_match_status, 'UNMATCHED'::text) AS identity_match_status
   FROM v_subscription_financial_status f
     JOIN stripe_subscriptions s ON s.id = f.subscription_id
     LEFT JOIN v_identity_by_customer i ON i.stripe_customer_id = f.customer_id
     LEFT JOIN v_contact_behavior b ON b.contact_id = i.ac_contact_id
  WHERE f.canceled_at IS NOT NULL;

CREATE OR REPLACE VIEW public.v_churn_analysis AS
 SELECT e.subscription_id,
    e.customer_id,
    e.email,
    e.identity_match_status,
    e.subscription_created,
    e.canceled_at,
    e.tenure_days,
    e.plan_name AS plan,
    e.plan_interval,
    e.plan_amount,
    s.status AS subscription_status,
    e.trial_start,
    e.trial_end,
    e.cancellation_reason,
    e.cancellation_feedback,
    e.financial_classification,
    e.churn_classification,
    e.classification_reason,
    e.first_paid_invoice_date,
    e.last_paid_invoice_date,
    e.paid_invoice_count,
    e.total_paid,
    e.invoice_count,
    e.open_invoice_count,
    e.uncollectible_count,
    e.zero_value_paid_count,
    e.segment,
    e.health_score,
    e.health_score_label,
    e.days_since_last_use,
    e.topics_started_60d,
    e.topics_unique_visited_60d,
    e.sessions_7d,
    e.activation_status,
    'atual'::text AS behavior_asof
   FROM v_churn_events e
     JOIN stripe_subscriptions s ON s.id = e.subscription_id;

CREATE OR REPLACE VIEW public.v_customer_identity_audit AS
 WITH por_cliente AS (
         SELECT c.id AS stripe_customer_id,
            lower(TRIM(BOTH FROM c.email)) AS email,
            count(s.id) AS subscriptions,
            count(s.id) FILTER (WHERE s.status = 'active'::text) AS active_subscriptions,
            count(s.id) FILTER (WHERE s.status = 'canceled'::text) AS canceled_subscriptions,
            max(s.created) FILTER (WHERE s.status = 'active'::text) AS latest_active_subscription,
            max(s.canceled_at) AS latest_canceled_subscription
           FROM stripe_customers c
             LEFT JOIN stripe_subscriptions s ON s.customer_id = c.id
          WHERE c.email IS NOT NULL AND TRIM(BOTH FROM c.email) <> ''::text
          GROUP BY c.id, (lower(TRIM(BOTH FROM c.email)))
        ), por_email AS (
         SELECT por_cliente.email,
            count(*) AS stripe_customers_no_email,
            max(por_cliente.latest_active_subscription) AS melhor_ativa,
            max(por_cliente.latest_canceled_subscription) AS melhor_cancelada
           FROM por_cliente
          GROUP BY por_cliente.email
        )
 SELECT p.email,
    p.stripe_customer_id,
    e.stripe_customers_no_email,
    p.subscriptions,
    p.active_subscriptions,
    p.canceled_subscriptions,
    p.latest_active_subscription,
    p.latest_canceled_subscription,
    COALESCE(i.identity_match_status, 'UNMATCHED'::text) AS identity_match_status,
        CASE
            WHEN e.stripe_customers_no_email = 1 THEN true
            WHEN p.latest_active_subscription IS NOT NULL AND p.latest_active_subscription = e.melhor_ativa THEN true
            ELSE false
        END AS candidate_current_customer,
        CASE
            WHEN e.stripe_customers_no_email = 1 THEN 'EMAIL_COM_UM_UNICO_CLIENTE_STRIPE'::text
            WHEN p.latest_active_subscription IS NOT NULL AND p.latest_active_subscription = e.melhor_ativa THEN 'SUGESTAO_ASSINATURA_ATIVA_MAIS_RECENTE_PRECISA_REVISAO_HUMANA'::text
            WHEN p.active_subscriptions = 0 AND p.canceled_subscriptions > 0 THEN 'SO_TEM_ASSINATURA_CANCELADA'::text
            WHEN p.subscriptions = 0 THEN 'CLIENTE_SEM_NENHUMA_ASSINATURA'::text
            ELSE 'MULTIPLOS_CANDIDATOS_PRECISA_REVISAO_HUMANA'::text
        END AS resolution_reason
   FROM por_cliente p
     JOIN por_email e ON e.email = p.email
     LEFT JOIN v_identity_by_customer i ON i.stripe_customer_id = p.stripe_customer_id;

CREATE OR REPLACE VIEW public.v_identity_ambiguous_active_canceled AS
 SELECT email,
    count(*) AS stripe_customers,
    sum(subscriptions) AS subscriptions,
    sum(active_subscriptions) AS active_subscriptions,
    sum(canceled_subscriptions) AS canceled_subscriptions,
    max(latest_active_subscription) AS latest_active_subscription,
    max(latest_canceled_subscription) AS latest_canceled_subscription,
    string_agg(stripe_customer_id, ' | '::text ORDER BY stripe_customer_id) AS stripe_customer_ids
   FROM v_customer_identity_audit
  WHERE identity_match_status = 'AMBIGUOUS'::text
  GROUP BY email
 HAVING sum(active_subscriptions) > 0::numeric AND sum(canceled_subscriptions) > 0::numeric;

CREATE OR REPLACE VIEW public.v_invoice_coverage_by_month AS
 SELECT to_char(s.created, 'YYYY-MM'::text) AS mes_criacao_subscription,
    count(*) AS subscriptions,
    count(*) FILTER (WHERE f.has_any_invoice) AS com_invoice,
    count(*) FILTER (WHERE NOT f.has_any_invoice) AS sem_invoice,
    count(*) FILTER (WHERE f.has_paid_invoice) AS com_invoice_paga,
    round(100.0 * count(*) FILTER (WHERE f.has_any_invoice)::numeric / NULLIF(count(*), 0)::numeric, 1) AS pct_com_invoice
   FROM stripe_subscriptions s
     JOIN v_subscription_financial_status f ON f.subscription_id = s.id
  GROUP BY (to_char(s.created, 'YYYY-MM'::text));

CREATE OR REPLACE VIEW public.v_mrr_intervals AS
 WITH ultima_paga AS (
         SELECT COALESCE(stripe_invoices.subscription_id, stripe_invoices.subscription_id_raw) AS sid,
            max(COALESCE(stripe_invoices.paid_at, stripe_invoices.created)) AS paid_at,
            count(*) AS n_pagas
           FROM stripe_invoices
          WHERE stripe_invoices.status = 'paid'::text AND stripe_invoices.amount_paid > 0::numeric AND COALESCE(stripe_invoices.subscription_id, stripe_invoices.subscription_id_raw) IS NOT NULL
          GROUP BY (COALESCE(stripe_invoices.subscription_id, stripe_invoices.subscription_id_raw))
        )
 SELECT s.id AS subscription_id,
    s.customer_id,
    s.plan_interval,
    s.plan_amount,
        CASE
            WHEN s.plan_interval = 'year'::text THEN s.plan_amount / 1200.0
            ELSE s.plan_amount / 100.0
        END AS mrr,
    s.status,
    s.cancellation_reason,
    s.cancel_at_period_end,
    s.created AS subscription_created,
    s.trial_end,
    s.canceled_at,
    s.current_period_end,
    up.paid_at AS ultima_cobranca_paga,
    COALESCE(up.n_pagas, 0::bigint) AS cobrancas_pagas,
    COALESCE(s.trial_end, s.created) AS mrr_start,
    LEAST(
        CASE
            WHEN s.canceled_at IS NULL THEN 'infinity'::timestamp with time zone
            WHEN s.cancel_at_period_end THEN s.current_period_end
            ELSE s.canceled_at
        END,
        CASE
            WHEN up.paid_at IS NULL THEN 'infinity'::timestamp with time zone
            ELSE up.paid_at +
            CASE
                WHEN s.plan_interval = 'year'::text THEN '730 days'::interval
                ELSE '60 days'::interval
            END
        END) AS mrr_end_raw,
        CASE
            WHEN s.cancellation_reason = 'cancellation_requested'::text THEN 'VOLUNTARY'::text
            WHEN s.cancellation_reason = ANY (ARRAY['payment_failed'::text, 'payment_disputed'::text]) THEN 'INVOLUNTARY'::text
            WHEN s.canceled_at IS NULL THEN NULL::text
            ELSE 'UNKNOWN'::text
        END AS churn_type
   FROM stripe_subscriptions s
     LEFT JOIN ultima_paga up ON up.sid = s.id
  WHERE s.plan_amount > 0::numeric AND s.status <> 'incomplete_expired'::text;

CREATE OR REPLACE VIEW public.v_mrr_ativos AS
 SELECT subscription_id,
    customer_id,
    plan_interval,
    plan_amount,
    mrr,
    status,
    cancellation_reason,
    cancel_at_period_end,
    subscription_created,
    trial_end,
    canceled_at,
    current_period_end,
    ultima_cobranca_paga,
    cobrancas_pagas,
    mrr_start,
    mrr_end_raw,
    churn_type,
        CASE
            WHEN mrr_end_raw = 'infinity'::timestamp with time zone THEN NULL::timestamp with time zone
            ELSE mrr_end_raw
        END AS mrr_end
   FROM v_mrr_intervals
  WHERE mrr_end_raw > mrr_start;


-- ----------------------------------------------------------------------------
-- 5. FUNCTIONS
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.fn_churn_mtd(p_data date)
 RETURNS TABLE(ref_date date, active_start integer, new_subs integer, churned integer, churn_rate_mtd numeric, vol integer, invol integer, unk integer, mrr_churned numeric)
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'pg_temp'
AS $function$
  with j as (
    select date_trunc('month', p_data)::timestamptz as d0,
           (p_data + 1)::timestamptz                as d1
  ),
  m as (
    select i.*,
           (i.mrr_start <= j.d0 and (i.mrr_end is null or i.mrr_end > j.d0)) as ativo_ini,
           (i.mrr_start <= j.d1 and (i.mrr_end is null or i.mrr_end > j.d1)) as ativo_fim,
           (i.mrr_start >  j.d0 and i.mrr_start <= j.d1)                     as nasceu
    from v_mrr_ativos i cross join j
  )
  select
    p_data,
    count(*) filter (where ativo_ini)::int,
    count(*) filter (where nasceu and not ativo_ini)::int,
    count(*) filter (where ativo_ini and not ativo_fim)::int,
    round(100.0 * count(*) filter (where ativo_ini and not ativo_fim)
          / nullif(count(*) filter (where ativo_ini)
                 + count(*) filter (where nasceu and not ativo_ini), 0), 2),
    count(*) filter (where ativo_ini and not ativo_fim and churn_type = 'VOLUNTARY')::int,
    count(*) filter (where ativo_ini and not ativo_fim and churn_type = 'INVOLUNTARY')::int,
    count(*) filter (where ativo_ini and not ativo_fim
                       and (churn_type is null or churn_type = 'UNKNOWN'))::int,
    round(coalesce(sum(mrr) filter (where ativo_ini and not ativo_fim), 0), 2)
  from m;
$function$
;

CREATE OR REPLACE FUNCTION public.fn_subscriber_churn(p_data date)
 RETURNS TABLE(ref_date date, active_start integer, new_subscribers integer, churned integer, churn_rate numeric, churned_voluntary integer, churned_involuntary integer, churned_unknown integer, mrr_churned numeric, active_mrr_start numeric)
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'pg_temp'
AS $function$
  with j as (
    select (p_data - 30)::timestamptz as d0, (p_data)::timestamptz as d1
  ),
  m as (
    select i.*,
           (i.mrr_start <= j.d0 and (i.mrr_end is null or i.mrr_end > j.d0)) as ativo_ini,
           (i.mrr_start <= j.d1 and (i.mrr_end is null or i.mrr_end > j.d1)) as ativo_fim,
           (i.mrr_start >  j.d0 and i.mrr_start <= j.d1)                     as nasceu
    from v_mrr_ativos i cross join j
  )
  select
    p_data,
    count(*) filter (where ativo_ini)::int,
    count(*) filter (where nasceu and not ativo_ini)::int,
    count(*) filter (where ativo_ini and not ativo_fim)::int,
    round(100.0 * count(*) filter (where ativo_ini and not ativo_fim)
          / nullif(count(*) filter (where ativo_ini)
                 + count(*) filter (where nasceu and not ativo_ini), 0), 2),
    count(*) filter (where ativo_ini and not ativo_fim and churn_type = 'VOLUNTARY')::int,
    count(*) filter (where ativo_ini and not ativo_fim and churn_type = 'INVOLUNTARY')::int,
    count(*) filter (where ativo_ini and not ativo_fim
                       and (churn_type is null or churn_type = 'UNKNOWN'))::int,
    round(coalesce(sum(mrr) filter (where ativo_ini and not ativo_fim), 0), 2),
    round(coalesce(sum(mrr) filter (where ativo_ini), 0), 2)
  from m;
$function$
;

CREATE OR REPLACE FUNCTION public.is_tdcos_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
  select exists (select 1 from public.tdcos_users
                 where user_id = auth.uid() and ativo and papel = 'ADMIN');
$function$
;

CREATE OR REPLACE FUNCTION public.is_tdcos_staff()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
  select exists (select 1 from public.tdcos_users
                 where user_id = auth.uid() and ativo);
$function$
;

CREATE OR REPLACE FUNCTION public.rls_auto_enable()
 RETURNS event_trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$function$
;

-- NOTE: the first-admin email below was replaced with a placeholder for this
-- public export. The production function holds the real founder address.
CREATE OR REPLACE FUNCTION public.tg_bootstrap_primeiro_admin()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
begin
  if lower(new.email) = lower('admin@example.com')
     and not exists (select 1 from public.tdcos_users
                     where papel = 'ADMIN' and ativo) then
    insert into public.tdcos_users (user_id, email, papel, ativo, ativado_em)
    values (new.id, new.email, 'ADMIN', true, now())
    on conflict (user_id) do nothing;

    insert into public.tdcos_user_audit
      (ator_email, alvo_user_id, alvo_email, acao, papel_depois, detalhe)
    values ('bootstrap', new.id, new.email, 'CONVIDADO', 'ADMIN',
            jsonb_build_object('origem', 'bootstrap automatico do Bloco 2',
                               'regra', 'so dispara se nao houver ADMIN ativo'));
  end if;
  return new;
end; $function$
;

CREATE OR REPLACE FUNCTION public.tg_protege_ultimo_admin()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
declare perdeu_admin boolean;
begin
  perdeu_admin := old.papel = 'ADMIN' and old.ativo and (
      tg_op = 'DELETE' or new.papel <> 'ADMIN' or new.ativo = false);
  if perdeu_admin and not exists (
      select 1 from public.tdcos_users
      where papel = 'ADMIN' and ativo and user_id <> old.user_id) then
    raise exception 'Operacao bloqueada: deixaria o TdCOS sem nenhum ADMIN ativo';
  end if;
  return case when tg_op = 'DELETE' then old else new end;
end; $function$
;


-- ----------------------------------------------------------------------------
-- 6. VIEWS (part 2: depend on the functions above or on part 1)
-- ----------------------------------------------------------------------------

CREATE OR REPLACE VIEW public.v_subscriber_churn_rolling30 AS
 SELECT ref_date,
    active_start,
    new_subscribers,
    churned,
    churn_rate,
    churned_voluntary,
    churned_involuntary,
    churned_unknown,
    mrr_churned,
    active_mrr_start
   FROM fn_subscriber_churn(CURRENT_DATE) fn_subscriber_churn(ref_date, active_start, new_subscribers, churned, churn_rate, churned_voluntary, churned_involuntary, churned_unknown, mrr_churned, active_mrr_start);

CREATE OR REPLACE VIEW public.v_kpi_comparacao AS
 SELECT o.period,
    o.value AS oficial,
    r.value AS reconstruido,
    round(r.value - o.value, 2) AS erro_pp,
    round(abs(r.value - o.value), 2) AS erro_abs_pp
   FROM kpi_snapshots o
     LEFT JOIN kpi_snapshots r ON r.period = o.period AND r.kpi_code = 'TDCCOS_RECONSTRUCTED_CHURN'::text
  WHERE o.kpi_code = 'STRIPE_SUBSCRIBER_CHURN'::text AND o.is_official
  ORDER BY o.period;

CREATE OR REPLACE VIEW public.v_historical_trajetoria AS
 SELECT month,
    day_of_month,
    dias_no_mes,
    churned_mtd,
    subscriber_churn_mtd,
    voluntary_churn_mtd,
    involuntary_churn_mtd,
    round(day_of_month::numeric / dias_no_mes::numeric, 4) AS fracao_mes,
    max(churned_mtd) OVER (PARTITION BY month) AS churned_final,
    max(subscriber_churn_mtd) OVER (PARTITION BY month) AS churn_rate_final
   FROM historical_snapshots
  ORDER BY month, day_of_month;

CREATE OR REPLACE VIEW public.v_forecast_erro_por_horizonte AS
 SELECT method,
    metric,
    days_before_close,
    count(*) AS n,
    round(avg(absolute_error), 3) AS mae,
    round(avg(signed_error), 3) AS vies,
    round(min(signed_error), 3) AS menor,
    round(max(signed_error), 3) AS maior,
    round(stddev_samp(signed_error), 3) AS desvio
   FROM forecast_outcomes
  WHERE actual_value IS NOT NULL
  GROUP BY method, metric, days_before_close
  ORDER BY method, metric, days_before_close DESC;

CREATE OR REPLACE VIEW public.v_wf_status AS
 WITH ultima AS (
         SELECT DISTINCT ON (wf_ac_snapshot.wf_code, wf_ac_snapshot.automation_id) wf_ac_snapshot.snapshot_date,
            wf_ac_snapshot.wf_code,
            wf_ac_snapshot.automation_id,
            wf_ac_snapshot.found,
            wf_ac_snapshot.ac_name,
            wf_ac_snapshot.status,
            wf_ac_snapshot.created_at,
            wf_ac_snapshot.updated_at,
            wf_ac_snapshot.entered_count,
            wf_ac_snapshot.exited_count,
            wf_ac_snapshot.raw,
            wf_ac_snapshot.source,
            wf_ac_snapshot.captured_at
           FROM wf_ac_snapshot
          ORDER BY wf_ac_snapshot.wf_code, wf_ac_snapshot.automation_id, wf_ac_snapshot.snapshot_date DESC
        )
 SELECT r.display_order,
    r.wf_code,
    r.wf_number,
    r.wf_name,
    r.signal_codes,
        CASE
            WHEN count(l.automation_id) = 0 THEN 'Automação não localizada no ActiveCampaign'::text
            WHEN count(u.automation_id) = 0 THEN 'Vinculada, ainda sem captura'::text
            WHEN bool_and(u.found) IS FALSE THEN 'Automação vinculada não encontrada na AC (removida?)'::text
            ELSE 'Localizada'::text
        END AS situacao,
    array_remove(array_agg(l.automation_id ORDER BY l.role, l.automation_id), NULL::text) AS automation_ids,
    array_remove(array_agg(u.ac_name ORDER BY l.role, l.automation_id), NULL::text) AS ac_names,
    bool_or(u.status = 1) AS ativa,
    sum(u.entered_count) AS entradas,
    sum(u.exited_count) AS saidas,
    max(u.updated_at) AS editada_em,
    max(u.captured_at) AS captured_at
   FROM wf_registry r
     LEFT JOIN wf_ac_link l ON l.wf_code = r.wf_code
     LEFT JOIN ultima u ON u.wf_code = l.wf_code AND u.automation_id = l.automation_id
  GROUP BY r.display_order, r.wf_code, r.wf_number, r.wf_name, r.signal_codes;

CREATE OR REPLACE VIEW public.v_wf_assessment_atual AS
 SELECT DISTINCT ON (wf_code) assessment_date,
    wf_code,
    automation_ids,
    avaliada,
    eligible_population,
    entered_population,
    cobertura,
    execucao,
    resultado,
    churn_relacionado,
    mrr,
    diagnostico,
    acao,
    evidencia,
    assessed_at
   FROM wf_assessment
  ORDER BY wf_code, assessment_date DESC;
