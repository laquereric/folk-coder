# Agentic SDLC: From Weeks to Hours

## Overview

Transform your software development lifecycle from weeks-months per cycle to hours-days. Learn to build AI-augmented development workflows where agents handle implementation, testing, and documentation while humans focus on intent, review, and strategic decisions.

**What You'll Build:** A complete agentic development pipeline that accelerates every phase of the SDLC while maintaining quality and human oversight.

---

## Module 1: The SDLC Revolution

### Lesson 1.1: Traditional SDLC Bottlenecks
```
Traditional SDLC (Weeks-Months per cycle)
┌─────────────────────────────────────────┐
│ 1. Requirements & Planning    (Weeks)   │
│ 2. System Design              (Weeks)   │
│ 3. Implementation & Coding    (Weeks-Mo)│
│ 4. Testing & QA               (Days-Wks)│
│ 5. Code Review                (Days)    │
│ 6. Deploy & Release           (Days)    │
│ 7. Monitoring & Observability (Ongoing) │
│ 8. Feedback & Iteration       (Cont.)   │
└─────────────────────────────────────────┘
```

### Lesson 1.2: The Agentic Transformation
```
Agentic SDLC (Hours-Days per cycle)
┌─────────────────────────────────────────┐
│ 1. Express Intent             (Minutes) │
│ 2. Agent Understands          (Seconds) │
│ 3. Agent Implements           (Minutes) │
│ 4. Agent Tests + Docs         (Minutes) │
│ 5. Human Review               (Min-Hrs) │
│ 6. Deploy & Ship              (Minutes) │
│ 7. Monitoring & Observability (Cont.)   │
│ 8. Learn & Iterate            (Ongoing) │
└─────────────────────────────────────────┘
```

### Lesson 1.3: Human-AI Collaboration Model
- Express intent, not implementation
- Review decisions, not syntax
- Strategic oversight vs tactical execution
- Quality gates remain human-controlled

---

## Module 2: Express Intent (Minutes)

### Lesson 2.1: From Requirements to Intent
```ruby
# Traditional: Detailed specification document
# Agentic: Concise intent expression

# Instead of 20-page PRD:
intent = AgenticSdlc::Intent.new(
  goal: "Add user authentication",
  constraints: ["Must use OAuth 2.0", "Support Google and GitHub"],
  acceptance: ["User can sign in", "Session persists across requests"],
  non_goals: ["Email/password auth", "2FA (phase 2)"]
)
```

### Lesson 2.2: Intent Quality Patterns
```ruby
# Good intent: Clear, bounded, verifiable
intent.express(<<~INTENT)
  Add a /health endpoint that returns:
  - HTTP 200 when database is connected
  - HTTP 503 with error details otherwise
  - Response time under 100ms
INTENT

# Poor intent: Vague, unbounded
# "Make the app faster" - no clear success criteria
# "Add authentication" - missing constraints
```

### Lesson 2.3: Intent Templates
```ruby
# Feature intent
AgenticSdlc::Templates::Feature.new(
  name: "Shopping Cart",
  user_story: "As a customer, I can add items to cart",
  given: ["User is logged in", "Product exists"],
  when: ["User clicks 'Add to Cart'"],
  then: ["Item appears in cart", "Cart count updates"]
)

# Bug fix intent
AgenticSdlc::Templates::BugFix.new(
  symptom: "Users see 500 error on checkout",
  reproduction: ["Add item", "Go to checkout", "Click pay"],
  expected: "Payment processes successfully",
  actual: "Server error on Stripe callback"
)
```

---

## Module 3: Agent Understands (Seconds)

### Lesson 3.1: Context Gathering
```ruby
# Agent automatically gathers context
class AgentUnderstanding
  def analyze(intent)
    {
      codebase_patterns: scan_existing_patterns,
      related_files: find_related_code(intent),
      dependencies: identify_dependencies,
      test_patterns: discover_test_conventions,
      deployment_config: read_deployment_setup
    }
  end
end
```

### Lesson 3.2: Clarification Loops
```ruby
# Agent asks targeted questions when needed
agent.understand(intent) do |clarification|
  case clarification.type
  when :ambiguity
    # "Should the health endpoint check Redis too?"
  when :constraint
    # "OAuth requires redirect URIs - what domain?"
  when :scope
    # "Should admin users have different auth flow?"
  end
end
```

### Lesson 3.3: Understanding Verification
```ruby
# Agent confirms understanding before implementing
understanding = agent.understand(intent)

puts understanding.summary
# => "I will add OAuth authentication using the Omniauth gem,
#     supporting Google and GitHub providers. I'll create a
#     SessionsController with create/destroy actions and add
#     the user model if it doesn't exist."

understanding.verify! # Raises if misaligned with intent
```

---

## Module 4: Agent Implements (Minutes)

### Lesson 4.1: Implementation Strategies
```ruby
class AgentImplementation
  def implement(understanding)
    plan = create_implementation_plan(understanding)

    plan.steps.each do |step|
      case step.type
      when :generate
        generate_code(step.specification)
      when :modify
        modify_existing(step.file, step.changes)
      when :configure
        update_configuration(step.config)
      end

      verify_step(step)
    end
  end
end
```

### Lesson 4.2: Code Generation Patterns
```ruby
# Agent follows existing patterns
class PatternMatcher
  def generate_controller(name, actions)
    existing_style = analyze_existing_controllers

    generate(
      template: :controller,
      style: existing_style,
      name: name,
      actions: actions,
      patterns: {
        error_handling: existing_style.error_pattern,
        authentication: existing_style.auth_pattern,
        response_format: existing_style.response_pattern
      }
    )
  end
end
```

### Lesson 4.3: Quick Refine Loop
```ruby
# Auto-fix on failure
implement_with_refinement(intent) do |result|
  if result.failed?
    case result.failure_type
    when :syntax_error
      auto_fix_syntax(result.error)
    when :test_failure
      refine_implementation(result.failing_tests)
    when :lint_error
      auto_fix_style(result.lint_errors)
    end

    retry_implementation
  end
end
```

---

## Module 5: Agent Tests + Docs (Minutes)

### Lesson 5.1: Test Generation
```ruby
class TestGenerator
  def generate_tests(implementation)
    tests = []

    # Unit tests for new methods
    tests += generate_unit_tests(implementation.new_methods)

    # Integration tests for workflows
    tests += generate_integration_tests(implementation.workflows)

    # Edge case tests from intent constraints
    tests += generate_edge_cases(implementation.intent.constraints)

    tests
  end
end
```

### Lesson 5.2: Documentation Generation
```ruby
class DocGenerator
  def generate(implementation)
    {
      readme_section: generate_readme(implementation),
      api_docs: generate_api_docs(implementation.endpoints),
      inline_comments: generate_comments(implementation.complex_logic),
      changelog_entry: generate_changelog(implementation.intent)
    }
  end

  def generate_api_docs(endpoints)
    endpoints.map do |endpoint|
      OpenAPISpec.new(
        path: endpoint.path,
        method: endpoint.method,
        parameters: infer_parameters(endpoint),
        responses: infer_responses(endpoint),
        examples: generate_examples(endpoint)
      )
    end
  end
end
```

### Lesson 5.3: Coverage and Quality Gates
```ruby
# Automated quality verification
class QualityGate
  THRESHOLDS = {
    test_coverage: 80,
    mutation_score: 60,
    complexity_max: 10,
    doc_coverage: 100
  }

  def verify(implementation)
    results = {
      coverage: measure_coverage(implementation.tests),
      mutations: run_mutation_testing(implementation),
      complexity: analyze_complexity(implementation.code),
      documentation: check_doc_coverage(implementation)
    }

    results.all? { |metric, score| score >= THRESHOLDS[metric] }
  end
end
```

---

## Module 6: Human Review (Minutes-Hours)

### Lesson 6.1: Review Interface
```ruby
# Structured review presentation
class ReviewPresenter
  def present(implementation)
    {
      summary: implementation.intent.summary,
      changes: group_changes_by_type(implementation),
      tests: summarize_test_coverage(implementation),
      risks: identify_potential_risks(implementation),
      questions: gather_review_questions(implementation)
    }
  end
end
```

### Lesson 6.2: Review Checklists
```ruby
# Auto-generated review checklist
class ReviewChecklist
  def generate(implementation)
    checklist = []

    checklist << "Intent alignment: Does code match expressed intent?"
    checklist << "Security: Are inputs validated? Auth checked?"
    checklist << "Performance: Any N+1 queries? Unbounded loops?"
    checklist << "Error handling: Are failures gracefully handled?"

    # Context-specific items
    if implementation.touches_database?
      checklist << "Migration: Is it reversible? Indexed?"
    end

    if implementation.touches_api?
      checklist << "API: Is it versioned? Documented?"
    end

    checklist
  end
end
```

### Lesson 6.3: Feedback Integration
```ruby
# Human feedback refines future implementations
class FeedbackLoop
  def record(review)
    Feedback.create!(
      implementation: review.implementation,
      approved: review.approved?,
      changes_requested: review.changes,
      patterns_learned: extract_patterns(review),
      anti_patterns: extract_anti_patterns(review)
    )
  end

  def learn_from_feedback
    recent = Feedback.recent.rejected
    recent.each do |feedback|
      update_guidelines(feedback.patterns_learned)
      add_anti_patterns(feedback.anti_patterns)
    end
  end
end
```

---

## Module 7: Deploy & Ship (Minutes)

### Lesson 7.1: Automated Deployment Pipeline
```ruby
class AgenticDeployment
  def deploy(implementation)
    pipeline = Pipeline.new

    pipeline.stage(:pre_flight) do
      run_full_test_suite
      check_security_scan
      verify_dependencies
    end

    pipeline.stage(:deploy) do
      if feature_flag_enabled?
        deploy_behind_flag
      else
        deploy_canary(percentage: 5)
      end
    end

    pipeline.stage(:verify) do
      run_smoke_tests
      check_error_rates
      verify_metrics
    end

    pipeline.execute!
  end
end
```

### Lesson 7.2: Rollback Automation
```ruby
# Auto-rollback on anomaly detection
class DeploymentMonitor
  def watch(deployment)
    metrics = collect_metrics(deployment)

    if anomaly_detected?(metrics)
      deployment.rollback!
      notify_team(
        type: :auto_rollback,
        reason: metrics.anomaly_description,
        deployment: deployment
      )
    end
  end

  def anomaly_detected?(metrics)
    metrics.error_rate > baseline.error_rate * 1.5 ||
    metrics.latency_p99 > baseline.latency_p99 * 2 ||
    metrics.success_rate < 0.99
  end
end
```

---

## Module 8: Monitoring & Observability (Continuous)

### Lesson 8.1: Automated Alerting
```ruby
class AgenticMonitoring
  def configure(deployment)
    alerts = []

    # Standard alerts
    alerts << ErrorRateAlert.new(threshold: 0.01)
    alerts << LatencyAlert.new(p99_threshold: 500.ms)

    # Intent-derived alerts
    deployment.intent.acceptance.each do |criterion|
      alerts << derive_alert_from_criterion(criterion)
    end

    register_alerts(alerts)
  end
end
```

### Lesson 8.2: Incident Detection
```ruby
# AI-assisted incident detection
class IncidentDetector
  def analyze(metrics, logs)
    anomalies = detect_anomalies(metrics)
    correlations = correlate_with_logs(anomalies, logs)

    if significant_incident?(correlations)
      Incident.create!(
        severity: calculate_severity(correlations),
        probable_cause: infer_cause(correlations),
        affected_users: estimate_impact(correlations),
        suggested_actions: suggest_remediation(correlations)
      )
    end
  end
end
```

---

## Module 9: Learn & Iterate (Ongoing)

### Lesson 9.1: Continuous Learning
```ruby
class LearningLoop
  def learn_from_production
    # Learn from successful deployments
    successful = Deployment.recent.successful
    extract_winning_patterns(successful)

    # Learn from incidents
    incidents = Incident.recent
    extract_failure_patterns(incidents)

    # Learn from feedback
    feedback = ReviewFeedback.recent
    update_agent_guidelines(feedback)
  end
end
```

### Lesson 9.2: Pattern Evolution
```ruby
# Patterns improve over time
class PatternEvolution
  def evolve(pattern)
    # Track pattern success rate
    success_rate = calculate_success_rate(pattern)

    if success_rate < 0.8
      # Pattern needs refinement
      refined = analyze_failures(pattern)
      update_pattern(pattern, refined)
    elsif success_rate > 0.95
      # Pattern is stable, can be shared
      promote_to_best_practice(pattern)
    end
  end
end
```

---

## Module 10: The AgenticSDLC Gem

### Lesson 10.1: Installation
```ruby
# Gemfile
gem 'agentic_sdlc'

# config/initializers/agentic_sdlc.rb
AgenticSdlc.configure do |config|
  config.llm_provider = :claude
  config.auto_test = true
  config.auto_doc = true
  config.human_review_required = true
  config.deployment_strategy = :canary
end
```

### Lesson 10.2: CLI Usage
```bash
# Express intent
agentic intent "Add user authentication with OAuth"

# Agent implements
agentic implement --intent-id=abc123

# Human review
agentic review --implementation-id=xyz789

# Deploy
agentic deploy --implementation-id=xyz789
```

### Lesson 10.3: Rails Integration
```ruby
# Integrated into development workflow
class DevelopmentController < ApplicationController
  def create_feature
    intent = AgenticSdlc::Intent.from_params(params)

    result = AgenticSdlc.pipeline do |p|
      p.express(intent)
      p.understand
      p.implement
      p.test_and_doc
      p.prepare_review
    end

    redirect_to review_path(result.review_id)
  end
end
```

---

## Module 11: Measuring Success

### Lesson 11.1: Cycle Time Metrics
```ruby
class CycleTimeTracker
  def track(implementation)
    {
      intent_to_understanding: measure(:intent, :understanding),
      understanding_to_implementation: measure(:understanding, :implementation),
      implementation_to_tests: measure(:implementation, :tests),
      tests_to_review: measure(:tests, :review),
      review_to_deploy: measure(:review, :deploy),
      total_cycle_time: measure(:intent, :deploy)
    }
  end

  def compare_to_traditional
    {
      traditional_average: 4.weeks,
      agentic_average: @metrics.average(:total_cycle_time),
      improvement_factor: 4.weeks / @metrics.average(:total_cycle_time)
    }
  end
end
```

### Lesson 11.2: Quality Metrics
```ruby
class QualityTracker
  def compare_quality
    {
      bug_rate: {
        traditional: bugs_per_feature(:traditional),
        agentic: bugs_per_feature(:agentic)
      },
      test_coverage: {
        traditional: avg_coverage(:traditional),
        agentic: avg_coverage(:agentic)  # Often higher due to auto-generation
      },
      documentation: {
        traditional: doc_completeness(:traditional),
        agentic: doc_completeness(:agentic)  # 100% with auto-doc
      }
    }
  end
end
```

---

## Module 12: Capstone Project

### Project: Agentic Feature Development

Build a complete feature using the Agentic SDLC:

1. **Express Intent** (5 minutes)
   - Write clear intent with acceptance criteria
   - Define constraints and non-goals

2. **Agent Understanding** (1 minute)
   - Verify agent's understanding
   - Clarify any ambiguities

3. **Agent Implementation** (10 minutes)
   - Watch agent generate code
   - Observe auto-fix loops

4. **Agent Tests + Docs** (5 minutes)
   - Review generated tests
   - Check documentation

5. **Human Review** (15 minutes)
   - Use review checklist
   - Provide feedback

6. **Deploy** (5 minutes)
   - Deploy with canary
   - Verify in production

**Total: ~40 minutes** vs traditional weeks-months

---

## Prerequisites

- Ruby on Rails intermediate experience
- Familiarity with CI/CD concepts
- Basic understanding of testing
- Experience with code review

## Learning Outcomes

By completing this curriculum, you will be able to:

- Transform SDLC from weeks to hours
- Express intent clearly for AI agents
- Review AI-generated implementations effectively
- Build automated deployment pipelines
- Measure and improve cycle time
- Maintain quality with AI acceleration
- Balance human oversight with automation
- Implement continuous learning loops
