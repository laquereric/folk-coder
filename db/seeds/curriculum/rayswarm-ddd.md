# Rayswarm: Domain-Driven Distributed Workers

## Overview

Rayswarm is a Domain-Driven Design pattern that combines four key elements into a modular Magentic distributed worker:

1. **Git Repository** - Version-controlled domain knowledge and code
2. **Rails Engine** - Pluggable Ruby on Rails module with models, controllers, and views
3. **Human Expert** - Domain specialist who curates and validates the knowledge
4. **Ray Library** - Python distributed computing framework for scalable execution

This curriculum teaches you how to create domain expert workers that can be composed into a distributed AI-powered system.

---

## Module 1: Foundations of Domain-Driven Workers

### Lesson 1.1: What is a Domain Expert Worker?
- Understanding bounded contexts in DDD
- The role of human expertise in AI systems
- Why modular workers beat monolithic systems
- Introduction to the Magentic ecosystem

### Lesson 1.2: Anatomy of a Rayswarm Worker
- Git repo as the source of truth
- Rails engine as the runtime container
- MCP tools as the capability interface
- Ray actors as distributed executors

### Lesson 1.3: The Human-in-the-Loop Pattern
- Domain experts as knowledge curators
- Validation workflows for AI outputs
- Feedback loops for continuous improvement
- Balancing automation with human oversight

---

## Module 2: Building Your First Rails Engine

### Lesson 2.1: Rails Engine Fundamentals
- Engine vs application architecture
- Namespacing and isolation
- Mounting engines in host applications
- Engine configuration patterns

### Lesson 2.2: Creating a Domain Engine
```ruby
# lib/my_domain/engine.rb
module MyDomain
  class Engine < ::Rails::Engine
    isolate_namespace MyDomain

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
```

### Lesson 2.3: Models and Migrations
- Engine-specific database tables
- Cross-engine associations
- Migration strategies for engines
- Data isolation patterns

### Lesson 2.4: Controllers and APIs
- JSON API controllers in engines
- Shared authentication patterns
- Rate limiting and quotas
- Error handling conventions

---

## Module 3: MCP Tool Integration

### Lesson 3.1: Model Context Protocol (MCP)
- What is MCP and why it matters
- Tool discovery and registration
- Input schemas with JSON Schema
- Output formats and streaming

### Lesson 3.2: Defining Domain Tools
```ruby
# lib/my_domain/tools/analyze_document.rb
module MyDomain
  module Tools
    class AnalyzeDocument < Rayswarm::MCP::Tool
      name "analyze_document"
      description "Analyzes a document using domain expertise"

      input_schema do
        required(:document_id).filled(:integer)
        optional(:depth).value(:string, included_in?: %w[quick standard deep])
      end

      def execute(document_id:, depth: "standard")
        document = MyDomain::Document.find(document_id)
        MyDomain::Analyzer.new(document, depth: depth).analyze
      end
    end
  end
end
```

### Lesson 3.3: Tool Registry Patterns
- Automatic tool discovery
- Conditional tool availability
- Tool versioning strategies
- Deprecation workflows

### Lesson 3.4: Testing MCP Tools
- Unit testing tool logic
- Integration testing with mock LLMs
- Schema validation tests
- Performance benchmarking

---

## Module 4: Ray Distributed Computing

### Lesson 4.1: Introduction to Ray
- Ray architecture overview
- Tasks vs Actors vs Serve
- Cluster setup and management
- Python-Ruby bridge concepts

### Lesson 4.2: Ray Actors for Domain Workers
```python
# bridge/actors/domain_worker.py
import ray

@ray.remote
class DomainWorker:
    def __init__(self, domain_config):
        self.config = domain_config
        self.model = self._load_model()

    def process(self, input_data):
        return self.model.predict(input_data)

    def _load_model(self):
        # Load domain-specific ML model
        pass
```

### Lesson 4.3: JSON-RPC-LD Bridge
- WebSocket communication protocol
- Request/response patterns
- Error handling across languages
- Connection pooling and health checks

### Lesson 4.4: Scaling with Ray Serve
- Deployment configurations
- Auto-scaling policies
- Load balancing strategies
- Monitoring and observability

---

## Module 5: Git Repository as Knowledge Base

### Lesson 5.1: Repository Structure Standards
```
my-domain-worker/
├── .claude/
│   ├── settings.json      # MCP configuration
│   └── architecture.puml  # Domain diagram
├── app/
│   ├── models/            # Domain models
│   ├── services/          # Business logic
│   └── tools/             # MCP tools
├── lib/
│   └── my_domain/
│       ├── engine.rb
│       └── version.rb
├── bridge/
│   └── actors/            # Ray actors
├── docs/
│   ├── domain/            # Domain knowledge
│   └── api/               # API documentation
├── spec/                  # Tests
├── CLAUDE.md              # AI context file
└── my_domain.gemspec
```

### Lesson 5.2: Domain Documentation
- Writing effective CLAUDE.md files
- Documenting domain concepts
- API documentation with OpenAPI
- PlantUML architecture diagrams

### Lesson 5.3: Version Control Strategies
- Semantic versioning for engines
- Changelog management
- Branch strategies for domain evolution
- Release workflows

---

## Module 6: Composing Domain Workers

### Lesson 6.1: Worker Orchestration
- Rayswarm Orchestrator patterns
- Load balancing across domains
- Cross-domain communication
- Transaction coordination

### Lesson 6.2: Building a Multi-Domain System
```ruby
# config/initializers/rayswarm.rb
Rayswarm.configure do |config|
  config.domains = [
    { name: "legal", engine: LegalDomain::Engine, port: 3101 },
    { name: "finance", engine: FinanceDomain::Engine, port: 3102 },
    { name: "medical", engine: MedicalDomain::Engine, port: 3103 }
  ]

  config.orchestrator.strategy = :least_loaded
  config.orchestrator.health_check_interval = 30.seconds
end
```

### Lesson 6.3: Domain Boundaries and Contracts
- Defining clear interfaces
- Event-driven communication
- Shared kernel patterns
- Anti-corruption layers

### Lesson 6.4: Testing Composed Systems
- Integration testing strategies
- Contract testing between domains
- Chaos engineering basics
- Performance testing at scale

---

## Module 7: Human Expert Workflows

### Lesson 7.1: Expert Validation Interfaces
- Building review UIs with Rails
- Approval workflows
- Annotation tools
- Feedback collection

### Lesson 7.2: Knowledge Curation
- Expert-driven content updates
- Training data management
- Model feedback loops
- Quality metrics

### Lesson 7.3: Continuous Improvement
- A/B testing domain changes
- Monitoring expert corrections
- Automated retraining triggers
- Knowledge base versioning

---

## Module 8: Production Deployment

### Lesson 8.1: Docker Containerization
```dockerfile
# Dockerfile for domain worker
FROM ruby:3.3-slim AS base
WORKDIR /rails

# Install Ray bridge dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install ray[default] websockets

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
CMD ["bin/rayswarm-worker"]
```

### Lesson 8.2: Kubernetes Deployment
- StatefulSets for Ray workers
- Service mesh integration
- Horizontal pod autoscaling
- Persistent volume management

### Lesson 8.3: Monitoring and Observability
- Prometheus metrics
- Distributed tracing
- Log aggregation
- Alerting strategies

### Lesson 8.4: Security Considerations
- Authentication between workers
- Data encryption in transit
- Secrets management
- Audit logging

---

## Capstone Project: Build a Domain Expert Worker

Create a complete Rayswarm domain worker for a field of your choice:

1. **Define the Domain**
   - Identify bounded context
   - Document domain concepts
   - Design MCP tools

2. **Build the Rails Engine**
   - Models and migrations
   - API controllers
   - Background jobs

3. **Implement Ray Actors**
   - Python bridge components
   - Distributed processing logic
   - Scaling configuration

4. **Create Expert Workflows**
   - Validation interfaces
   - Feedback collection
   - Quality dashboards

5. **Deploy and Monitor**
   - Docker/Kubernetes setup
   - Observability stack
   - Documentation

---

## Prerequisites

- Ruby on Rails intermediate experience
- Basic Python knowledge
- Familiarity with Git workflows
- Understanding of REST APIs
- Docker basics

## Learning Outcomes

By completing this curriculum, you will be able to:

- Design domain-driven distributed systems
- Build modular Rails engines as workers
- Implement MCP tools for AI integration
- Use Ray for distributed computing
- Create human-in-the-loop workflows
- Deploy and scale domain expert systems
- Compose multiple domains into unified platforms
