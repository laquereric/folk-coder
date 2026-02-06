# Intent Compiler: Context-First Development

## Overview

Move beyond code-first development. Learn to build systems where human intention, decision rationale, and business context are first-class citizens—preserved, versioned, and compiled alongside implementation code.

**What You'll Build:** A complete intent-driven development workflow where context compiles to code, decisions are traceable, and knowledge survives team turnover.

---

## Module 1: The Context Crisis

### Lesson 1.1: The Hidden Compilation Step
- How we've optimized the wrong problem for decades
- The two-step compilation: Human Intention → Code → Machine
- Why syntax compiles perfectly but context compilation fails
- Real costs of lost institutional knowledge

### Lesson 1.2: Anatomy of a Context Failure
- Inheriting codebases with zero decision rationale
- The "why" behind architectural choices
- Edge cases the design addresses
- System relationships invisible in code

### Lesson 1.3: The Knowledge Debt Problem
- Team turnover and lost reasoning
- Onboarding costs compound over time
- Technical debt vs context debt
- Case study: A codebase autopsy

---

## Module 2: Intention Architecture

### Lesson 2.1: The Four-Layer Model
```ruby
# Intent Compiler layers
module IntentCompiler
  module Layers
    # Layer 1: What problem are we solving?
    class RequirementsLayer
      # User stories, business goals, success criteria
    end

    # Layer 2: What constraints exist?
    class ConstraintLayer
      # Technical limits, regulations, resources
    end

    # Layer 3: What decisions were made?
    class DecisionLayer
      # Options considered, trade-offs, rationale
    end

    # Layer 4: How is it implemented?
    class ImplementationLayer
      # Code mapped to intentions
    end
  end
end
```

### Lesson 2.2: Bidirectional Mapping
- Code ↔ Decision ↔ Constraint ↔ Requirement
- Tracing implementation to business need
- Tracing business need to implementation
- Maintaining coupling through changes

### Lesson 2.3: Decision Trees
- Options considered vs options chosen
- Documenting eliminated alternatives
- Trade-off matrices
- Constraint satisfaction

---

## Module 3: The Intent Document

### Lesson 3.1: Intent Document Structure
```yaml
# .intent/features/user_authentication.yml
intent:
  id: auth-001
  title: User Authentication System

  requirements:
    - Users must authenticate before accessing protected resources
    - Support both email/password and OAuth providers
    - Session timeout after 30 minutes of inactivity

  constraints:
    - Must comply with SOC 2 requirements
    - Cannot store plaintext passwords
    - Must support existing LDAP infrastructure

  decisions:
    - id: auth-001-d1
      question: "Which session storage mechanism?"
      options:
        - name: JWT tokens
          pros: [stateless, scalable]
          cons: [cannot revoke, larger payload]
        - name: Server-side sessions
          pros: [revocable, smaller tokens]
          cons: [requires session store, less scalable]
      chosen: JWT tokens
      rationale: |
        Scalability is critical for our microservices architecture.
        Revocation handled via short expiration + refresh tokens.

  implementation:
    files:
      - app/controllers/sessions_controller.rb
      - app/services/jwt_encoder.rb
      - app/middleware/authentication.rb
```

### Lesson 3.2: Linking Code to Intent
```ruby
# app/controllers/sessions_controller.rb

# @intent auth-001
# @decision auth-001-d1
# @constraint SOC2-encryption
class SessionsController < ApplicationController
  # @requirement "Session timeout after 30 minutes"
  SESSION_TIMEOUT = 30.minutes

  def create
    # @decision auth-001-d1: Using JWT tokens for scalability
    token = JwtEncoder.encode(user_id: user.id, exp: SESSION_TIMEOUT.from_now)
    render json: { token: token }
  end
end
```

### Lesson 3.3: Intent Validation
- Verifying all requirements have implementations
- Detecting orphaned code (no linked intent)
- Constraint compliance checking
- Decision coverage reports

---

## Module 4: The Compiler Pipeline

### Lesson 4.1: Intent Parser
```ruby
# lib/intent_compiler/parser.rb
module IntentCompiler
  class Parser
    def parse(intent_file)
      content = YAML.load_file(intent_file)
      Intent.new(
        requirements: parse_requirements(content),
        constraints: parse_constraints(content),
        decisions: parse_decisions(content),
        implementation: parse_implementation(content)
      )
    end
  end
end
```

### Lesson 4.2: Code Generator
```ruby
# lib/intent_compiler/generator.rb
module IntentCompiler
  class Generator
    def generate(intent)
      templates = select_templates(intent)

      templates.map do |template|
        CodeUnit.new(
          path: template.output_path(intent),
          content: template.render(intent),
          intent_refs: [intent.id]
        )
      end
    end
  end
end
```

### Lesson 4.3: Synchronization Engine
- Detecting intent-code drift
- Updating code when intent changes
- Updating intent when code changes
- Merge conflict resolution

---

## Module 5: Context Preservation

### Lesson 5.1: Git Integration
```ruby
# lib/intent_compiler/git_hooks.rb
module IntentCompiler
  class PreCommitHook
    def run
      changed_files = `git diff --cached --name-only`.split("\n")

      changed_files.each do |file|
        intent_refs = extract_intent_refs(file)
        verify_intent_exists(intent_refs)
        update_intent_timestamps(intent_refs)
      end
    end
  end
end
```

### Lesson 5.2: Decision Changelog
```yaml
# .intent/changelog/2024-01.yml
changes:
  - date: 2024-01-15
    intent: auth-001
    decision: auth-001-d1
    type: revision
    from: "Server-side sessions"
    to: "JWT tokens"
    author: alice@example.com
    rationale: |
      Moving to microservices architecture requires
      stateless authentication. Existing session store
      cannot scale across services.
```

### Lesson 5.3: Knowledge Graph
- Building relationships between intents
- Dependency tracking
- Impact analysis for changes
- Visualization tools

---

## Module 6: Rails Integration

### Lesson 6.1: The IntentCompiler Engine
```ruby
# lib/intent_compiler/engine.rb
module IntentCompiler
  class Engine < ::Rails::Engine
    isolate_namespace IntentCompiler

    initializer "intent_compiler.load_intents" do
      IntentCompiler.load_intents(Rails.root.join(".intent"))
    end

    config.generators do |g|
      g.templates.unshift File.expand_path("templates", __dir__)
    end
  end
end
```

### Lesson 6.2: Intent-Aware Generators
```ruby
# lib/generators/intent_compiler/scaffold_generator.rb
module IntentCompiler
  class ScaffoldGenerator < Rails::Generators::NamedBase
    argument :intent_id, type: :string

    def create_model
      intent = IntentCompiler.find_intent(intent_id)

      template "model.rb.erb",
        "app/models/#{file_name}.rb",
        intent: intent
    end

    def update_intent_implementation
      IntentCompiler.link_implementation(
        intent_id: intent_id,
        files: generated_files
      )
    end
  end
end
```

### Lesson 6.3: Controller Helpers
```ruby
# app/controllers/concerns/intent_traceable.rb
module IntentTraceable
  extend ActiveSupport::Concern

  class_methods do
    def intent(intent_id, **options)
      before_action(options) do
        @current_intent = IntentCompiler.find_intent(intent_id)
      end
    end
  end

  def trace_decision(decision_id, &block)
    IntentCompiler.trace(
      decision: decision_id,
      context: request_context,
      &block
    )
  end
end
```

---

## Module 7: AI-Assisted Intent

### Lesson 7.1: Intent Extraction
```ruby
# lib/intent_compiler/ai/extractor.rb
module IntentCompiler
  module AI
    class Extractor
      def extract_from_code(file_path)
        code = File.read(file_path)

        prompt = <<~PROMPT
          Analyze this code and extract:
          1. The likely requirements it fulfills
          2. Constraints it operates under
          3. Design decisions embedded in it
          4. Alternative approaches not taken

          #{code}
        PROMPT

        response = llm_client.chat(prompt)
        parse_intent_response(response)
      end
    end
  end
end
```

### Lesson 7.2: Intent-Driven Code Generation
```ruby
# Using LLM to generate implementation from intent
class IntentToCodeGenerator
  def generate(intent)
    prompt = <<~PROMPT
      Generate Ruby code that fulfills these requirements:
      #{intent.requirements.to_yaml}

      Under these constraints:
      #{intent.constraints.to_yaml}

      Following these decisions:
      #{intent.decisions.to_yaml}
    PROMPT

    code = llm_client.chat(prompt)
    annotate_with_intent_refs(code, intent)
  end
end
```

### Lesson 7.3: Conversational Intent Capture
```ruby
# Interactive intent building
class IntentWizard
  def run
    puts "What problem are you solving?"
    problem = gets.chomp

    requirements = expand_requirements(problem)
    constraints = identify_constraints(requirements)
    decisions = explore_decisions(requirements, constraints)

    Intent.new(
      requirements: requirements,
      constraints: constraints,
      decisions: decisions
    )
  end
end
```

---

## Module 8: Testing Intent

### Lesson 8.1: Intent Specification Tests
```ruby
# spec/intents/authentication_spec.rb
RSpec.describe "Authentication Intent (auth-001)" do
  let(:intent) { IntentCompiler.find_intent("auth-001") }

  describe "requirements coverage" do
    it "has implementation for all requirements" do
      intent.requirements.each do |req|
        expect(req.implementations).not_to be_empty,
          "Requirement '#{req.text}' has no implementation"
      end
    end
  end

  describe "constraint compliance" do
    it "never stores plaintext passwords" do
      password_stores = grep_codebase(/password.*=/)
      password_stores.each do |location|
        expect(location).to be_encrypted_storage
      end
    end
  end

  describe "decision consistency" do
    it "uses JWT tokens everywhere" do
      auth_code = intent.implementation_files
      expect(auth_code).to all(use_jwt_pattern)
    end
  end
end
```

### Lesson 8.2: Intent Regression Tests
```ruby
# Detect when code changes violate original intent
class IntentRegressionGuard
  def check(commit)
    changed_intents = IntentCompiler.affected_intents(commit.files)

    changed_intents.each do |intent|
      violations = check_violations(intent, commit)

      if violations.any?
        raise IntentViolation.new(
          intent: intent,
          violations: violations,
          commit: commit
        )
      end
    end
  end
end
```

### Lesson 8.3: Living Documentation
- Auto-generating docs from intent
- Keeping docs in sync with code
- Intent-based API documentation
- Architecture decision records (ADRs)

---

## Module 9: Team Workflows

### Lesson 9.1: Intent-First Development
```
1. Write Intent Document
   - Define requirements
   - Document constraints
   - Record decision options

2. Review Intent (PR)
   - Team validates understanding
   - Stakeholders approve direction
   - Alternatives discussed

3. Generate Scaffolding
   - Intent compiles to code skeleton
   - Tests generated from requirements
   - Documentation created

4. Implement Details
   - Fill in generated structure
   - Maintain intent references
   - Update intent if needed

5. Validate & Merge
   - Intent coverage checks pass
   - Constraint compliance verified
   - Knowledge preserved
```

### Lesson 9.2: Onboarding with Intent
```ruby
# bin/intent-tour
class IntentTour
  def run(feature_area)
    intents = IntentCompiler.intents_for_area(feature_area)

    intents.each do |intent|
      display_intent_summary(intent)
      show_key_decisions(intent)
      link_to_implementation(intent)

      puts "Ready to continue? (y/n)"
      break unless gets.chomp == "y"
    end
  end
end
```

### Lesson 9.3: Code Review with Context
- Reviewing decisions, not just code
- Checking intent alignment
- Validating constraint compliance
- Knowledge transfer in PRs

---

## Module 10: Production Patterns

### Lesson 10.1: Intent Versioning
```yaml
# .intent/features/user_authentication.yml
intent:
  id: auth-001
  version: 2.1.0

  history:
    - version: 1.0.0
      date: 2023-06-01
      summary: Initial email/password auth

    - version: 2.0.0
      date: 2024-01-15
      summary: Migrated to JWT tokens
      breaking_changes:
        - Session storage no longer used
        - Clients must handle token refresh

    - version: 2.1.0
      date: 2024-03-01
      summary: Added OAuth support
```

### Lesson 10.2: Cross-Service Intent
```yaml
# Shared intent across microservices
intent:
  id: payment-flow-001
  scope: cross-service

  services:
    - name: order-service
      responsibility: Create payment intent

    - name: payment-service
      responsibility: Process payment

    - name: notification-service
      responsibility: Send confirmation

  contracts:
    - from: order-service
      to: payment-service
      event: payment.requested
      schema: schemas/payment_request.json
```

### Lesson 10.3: Intent Observability
```ruby
# Runtime intent tracing
class IntentTracer
  def trace(intent_id, &block)
    span = tracer.start_span(
      "intent.#{intent_id}",
      attributes: {
        "intent.id" => intent_id,
        "intent.version" => IntentCompiler.version_of(intent_id)
      }
    )

    begin
      yield span
    ensure
      span.finish
    end
  end
end
```

---

## Module 11: Migration Strategies

### Lesson 11.1: Extracting Intent from Legacy Code
```ruby
# Reverse-engineering intent from existing systems
class LegacyIntentExtractor
  def extract(codebase_path)
    # Phase 1: Static analysis
    code_structure = analyze_structure(codebase_path)

    # Phase 2: Git archaeology
    decision_history = analyze_git_history(codebase_path)

    # Phase 3: AI assistance
    inferred_intent = ai_infer_intent(code_structure)

    # Phase 4: Human validation
    IntentWizard.validate(inferred_intent)
  end
end
```

### Lesson 11.2: Incremental Adoption
```
Week 1-2: Document new features with intent
Week 3-4: Add intent to high-churn areas
Week 5-8: Extract intent from core modules
Ongoing: Intent-first for all new development
```

### Lesson 11.3: Measuring Success
- Time to understand new code areas
- Onboarding velocity improvements
- Decision reversals (intent prevented)
- Knowledge retention metrics

---

## Module 12: Capstone Project

### Project: Intent-Compiled Feature

Build a complete feature using intent-first development:

1. **Intent Document**
   - Requirements from stakeholders
   - Technical constraints identified
   - Decision options explored
   - Trade-offs documented

2. **Generated Scaffolding**
   - Models from intent
   - Controllers with intent refs
   - Tests from requirements

3. **Implementation**
   - Code linked to decisions
   - Constraints validated
   - Full traceability

4. **Documentation**
   - Auto-generated from intent
   - Decision rationale included
   - Onboarding guide created

5. **Validation**
   - Intent coverage 100%
   - All constraints satisfied
   - Team knowledge transfer demonstrated

---

## Prerequisites

- Ruby on Rails intermediate experience
- Basic understanding of software architecture
- Experience with team development workflows
- Familiarity with version control (Git)

## Learning Outcomes

By completing this curriculum, you will be able to:

- Design intent-first development workflows
- Create and maintain intent documents
- Build bidirectional code-to-intent mappings
- Preserve decision rationale alongside code
- Extract intent from legacy codebases
- Integrate intent compilation with Rails
- Test intent coverage and compliance
- Lead team adoption of context-first development
- Dramatically reduce onboarding time
- Prevent knowledge loss during team transitions
