# Founder user for local development (admin)
founder = User.find_or_create_by!(email_address: "founder@folkcoder.com") do |u|
  u.name = "Founder"
  u.password = "founder123"
  u.role = "admin"
end
# Ensure founder is always admin (in case already existed)
founder.update!(role: "admin") unless founder.admin?
puts "Seeded founder user: #{founder.email_address} (password: founder123, role: admin)"

# Curriculum: SwarmPod Fundamentals
mod = CurriculumModule.find_or_create_by!(title: "SwarmPod Fundamentals") do |m|
  m.description = "Learn the core concepts behind SwarmPod's architecture and workflow."
  m.position = 1
end

lessons = [
  {
    title: "Understanding Multi-Repo Architecture",
    description: "Learn why SwarmPod uses separate repositories and how they connect.",
    position: 1,
    content: <<~CONTENT
      Multi-repo architecture is a strategy where each component of a system lives in its own Git repository. This contrasts with a monorepo, where all code resides in a single repository.

      SwarmPod uses multi-repo architecture because it mirrors how professional teams actually ship software. Each repository can have its own CI/CD pipeline, its own release cycle, and its own team of maintainers.

      Key benefits:
      - Independent deployment: Ship one component without redeploying everything
      - Clear ownership: Each repo has a defined team responsible for it
      - Focused testing: Run only the tests relevant to the component you changed
      - Reduced blast radius: A bad deploy only affects one service

      In SwarmPod, the core gem lives in one repo, the template in another, and each generated application gets its own repo. This separation keeps concerns clean and enables true modularity.

      Think of it like microservices for your codebase — each piece is self-contained, versioned, and deployable on its own terms.
    CONTENT
  },
  {
    title: "Secrets Management Best Practices",
    description: "Keep credentials safe with environment variables and encrypted secrets.",
    position: 2,
    content: <<~CONTENT
      One of the most critical aspects of professional software development is keeping secrets — API keys, database passwords, tokens — out of your source code.

      SwarmPod enforces secrets management from the start. When you generate a new application, credentials are stored outside the repository using Rails' built-in encrypted credentials system.

      The golden rules of secrets management:
      - Never commit secrets to version control (even in private repos)
      - Use environment variables for runtime configuration
      - Use Rails credentials for application-level secrets
      - Rotate secrets regularly and after any suspected breach
      - Use different secrets for development, staging, and production

      Rails provides `bin/rails credentials:edit` to manage encrypted secrets. The encryption key (master.key) is gitignored by default. In production, you set the RAILS_MASTER_KEY environment variable.

      SwarmPod takes this further by providing a structured approach to secrets across multiple repositories, ensuring each component only has access to the secrets it needs.
    CONTENT
  },
  {
    title: "Docker & Containerization",
    description: "Understand containers and how Docker makes environments reproducible.",
    position: 3,
    content: <<~CONTENT
      Docker containers solve the "works on my machine" problem by packaging your application with everything it needs to run: code, runtime, libraries, and system tools.

      SwarmPod includes a Docker Compose setup that creates a consistent development environment for every team member. When you run `docker compose up`, you get the exact same environment as everyone else on your team.

      Core Docker concepts:
      - Image: A blueprint for a container (like a class in OOP)
      - Container: A running instance of an image (like an object)
      - Dockerfile: Instructions for building an image
      - Docker Compose: A tool for defining multi-container applications
      - Volume: Persistent storage that survives container restarts

      SwarmPod's Docker setup includes:
      - A Rails application container with all dependencies
      - SQLite database storing data to a permanent volume
      - Volume mounts for live code reloading during development
      - Health checks to ensure services are ready before accepting connections

      The key insight is that containerization isn't just for deployment — it's for development too. By developing inside containers, you catch environment-specific issues before they reach production.
    CONTENT
  },
  {
    title: "GitHub Actions & CI/CD",
    description: "Automate testing and deployment with continuous integration pipelines.",
    position: 4,
    content: <<~CONTENT
      Continuous Integration (CI) and Continuous Deployment (CD) are practices where code changes are automatically tested and deployed. GitHub Actions is GitHub's built-in CI/CD platform.

      SwarmPod applications are designed to work with GitHub Actions from day one. Every push triggers automated tests, linting, and security checks.

      A typical CI/CD pipeline includes:
      - Lint: Check code style and formatting (RuboCop for Ruby)
      - Test: Run your test suite (Minitest or RSpec)
      - Security: Scan for vulnerabilities (Brakeman, bundler-audit)
      - Build: Create a Docker image
      - Deploy: Push to production (using Kamal)

      GitHub Actions uses YAML workflow files stored in `.github/workflows/`. Each workflow defines triggers (push, pull request) and jobs (sequences of steps).

      Key concepts:
      - Workflow: An automated process defined in YAML
      - Job: A set of steps that execute on the same runner
      - Step: An individual task (run a command, use an action)
      - Action: A reusable unit of code (like a gem for CI)
      - Secret: Encrypted environment variables for sensitive data

      The multi-repo architecture means each repository gets its own CI/CD pipeline, allowing independent testing and deployment of each component.
    CONTENT
  },
  {
    title: "Deploying Your SwarmPod Application",
    description: "Ship your application to production with Kamal and Docker.",
    position: 5,
    content: <<~CONTENT
      Deployment is where everything comes together. SwarmPod uses Kamal, a deployment tool from 37signals (the creators of Rails), to ship containerized applications to any server.

      Kamal takes the Docker image you built and deploys it to your production server with zero downtime. It handles:
      - Building and pushing Docker images
      - Rolling deployments (new version starts before old one stops)
      - SSL certificates via Let's Encrypt
      - Health checks before routing traffic
      - Environment variable management
      - Database migrations via entrypoint scripts

      The deployment workflow:
      1. Push your code to GitHub
      2. CI runs tests and builds a Docker image
      3. Run `kamal deploy` to ship to production
      4. Kamal pulls the image, starts new containers, runs health checks
      5. Traffic is routed to the new containers
      6. Old containers are stopped and cleaned up

      SwarmPod's deploy configuration lives in `config/deploy.yml`. This file defines your server addresses, Docker registry, environment variables, and deployment options.

      Key production considerations:
      - Always run `db:prepare` (not `db:migrate`) in production entrypoints
      - Use a reverse proxy (Kamal includes Traefik) for SSL and load balancing
      - Monitor your application with logging and error tracking
      - Set up database backups before your first deploy
      - Use a staging environment to catch issues before production

      With SwarmPod, you go from `rails new` to a production deployment with a professional-grade setup. The hard part — the infrastructure — is already done. Now you can focus on building.
    CONTENT
  }
]

lessons.each do |attrs|
  Lesson.find_or_create_by!(title: attrs[:title], curriculum_module_id: mod.id) do |l|
    l.description = attrs[:description]
    l.content = attrs[:content]
    l.position = attrs[:position]
  end
end

# Curriculum: Coding Agents (no prerequisites)
coding_agents_mod = CurriculumModule.find_or_create_by!(title: "Coding Agents") do |m|
  m.description = "Learn to build and deploy AI-powered coding agents that augment your development workflow."
  m.position = 2
end
# Remove any existing prerequisite
coding_agents_mod.update!(prerequisite_module: nil) if coding_agents_mod.prerequisite_module

coding_agents_lessons = [
  {
    title: "Introduction to Coding Agents",
    description: "Understand what coding agents are and how they transform software development.",
    position: 1,
    content: <<~CONTENT
      Coding agents are AI-powered assistants that can read, understand, and write code. Unlike simple code completion tools, agents can reason about entire codebases, execute multi-step tasks, and collaborate with developers on complex problems.

      The evolution of AI in coding:
      - Autocomplete: Simple pattern matching (early IDEs)
      - Code completion: ML-based suggestions (Copilot, TabNine)
      - Coding agents: Autonomous task execution (Claude Code, Cursor, Aider)

      What makes an agent different from a chatbot?
      - Tool use: Agents can read files, run commands, search codebases
      - Memory: Agents maintain context across a session
      - Autonomy: Agents can plan and execute multi-step tasks
      - Feedback loops: Agents can observe results and adjust their approach

      Key capabilities of modern coding agents:
      - Code generation from natural language descriptions
      - Bug diagnosis and automated fixes
      - Refactoring with understanding of side effects
      - Test generation based on implementation
      - Documentation generation from code
      - Code review and security analysis

      The human-agent collaboration model:
      Agents work best as collaborators, not replacements. You provide intent, context, and judgment. The agent provides speed, consistency, and tireless attention to detail. Together, you achieve more than either could alone.

      In this curriculum, you'll learn to build agents that integrate into your SwarmPod workflow, automating repetitive tasks while keeping you in control of the important decisions.
    CONTENT
  },
  {
    title: "The Anthropic API & Claude Models",
    description: "Connect to Claude via the Anthropic API and understand model capabilities.",
    position: 2,
    content: <<~CONTENT
      The Anthropic API provides access to Claude, the AI model powering your coding agents. Understanding how to use this API effectively is fundamental to building capable agents.

      API Basics:
      The Anthropic API uses a simple request/response pattern. You send messages, Claude responds. Each request includes:
      - Model: Which Claude model to use (claude-sonnet-4-20250514, claude-opus-4-20250514)
      - Messages: The conversation history
      - System prompt: Instructions that shape Claude's behavior
      - Max tokens: Limit on response length

      Model Selection:
      - Claude Sonnet: Fast, capable, cost-effective — ideal for most coding tasks
      - Claude Opus: Most capable, best for complex reasoning and architecture decisions
      - Claude Haiku: Fastest, cheapest — good for simple tasks and high-volume operations

      Authentication:
      ```ruby
      require 'anthropic'

      client = Anthropic::Client.new(api_key: ENV['ANTHROPIC_API_KEY'])

      response = client.messages.create(
        model: 'claude-sonnet-4-20250514',
        max_tokens: 4096,
        messages: [{ role: 'user', content: 'Write a Ruby method to validate email addresses' }]
      )
      ```

      Conversation Structure:
      Messages alternate between 'user' and 'assistant' roles. For agents, you'll often include:
      - System prompt with tool definitions and behavior instructions
      - User messages with tasks and context
      - Assistant messages with previous responses
      - Tool results when the agent has executed actions

      Best Practices:
      - Keep system prompts focused and specific
      - Provide relevant context (file contents, error messages)
      - Use streaming for better UX on long responses
      - Implement retry logic with exponential backoff
      - Cache responses when appropriate to reduce costs

      Rate Limits & Costs:
      Monitor your usage through the Anthropic console. Set up alerts for unexpected spikes. For production agents, implement request queuing to stay within limits.
    CONTENT
  },
  {
    title: "Tool Use & Function Calling",
    description: "Give your agent the ability to take actions by defining and using tools.",
    position: 3,
    content: <<~CONTENT
      Tools transform Claude from a conversational AI into an agent that can take actions. By defining tools, you give Claude the ability to read files, execute commands, search the web, and interact with external systems.

      How Tool Use Works:
      1. You define available tools in your API request
      2. Claude decides when to use a tool based on the task
      3. Claude returns a tool_use response with the tool name and arguments
      4. Your code executes the tool and returns the result
      5. Claude continues with the tool result as context

      Defining a Tool:
      ```ruby
      tools = [
        {
          name: 'read_file',
          description: 'Read the contents of a file from the filesystem',
          input_schema: {
            type: 'object',
            properties: {
              path: {
                type: 'string',
                description: 'The file path to read'
              }
            },
            required: ['path']
          }
        }
      ]
      ```

      Essential Tools for Coding Agents:
      - read_file: Read source code and configuration
      - write_file: Create or update files
      - list_directory: Explore project structure
      - execute_command: Run tests, linters, builds
      - search_code: Find patterns across the codebase
      - git_operations: Commit, diff, branch management

      Tool Design Principles:
      - Single responsibility: Each tool does one thing well
      - Clear descriptions: Claude uses these to decide when to call tools
      - Safe defaults: Prefer read operations over writes
      - Confirmations: Require human approval for destructive actions
      - Error handling: Return clear error messages Claude can understand

      The Agent Loop:
      ```ruby
      loop do
        response = client.messages.create(model:, messages:, tools:)

        if response.stop_reason == 'tool_use'
          tool_results = execute_tools(response.content)
          messages << { role: 'assistant', content: response.content }
          messages << { role: 'user', content: tool_results }
        else
          break # Claude is done
        end
      end
      ```

      This loop continues until Claude decides no more tool calls are needed, giving you an autonomous agent that can complete multi-step tasks.
    CONTENT
  },
  {
    title: "Building a Code Review Agent",
    description: "Create an agent that reviews pull requests and suggests improvements.",
    position: 4,
    content: <<~CONTENT
      A code review agent demonstrates the power of combining Claude's code understanding with tool use. This agent can analyze diffs, check for common issues, and provide actionable feedback.

      Agent Architecture:
      ```
      [GitHub Webhook] → [Review Agent] → [Claude API]
                              ↓
                        [Tools: git diff, read_file, search_code]
                              ↓
                        [Post Review Comments]
      ```

      System Prompt Design:
      ```
      You are a code review agent for a Ruby on Rails application.

      Your review should check for:
      - Security vulnerabilities (SQL injection, XSS, mass assignment)
      - Performance issues (N+1 queries, missing indexes)
      - Code style violations (based on .rubocop.yml)
      - Missing tests for new functionality
      - Breaking changes to public APIs

      Be constructive and specific. Suggest fixes, don't just point out problems.
      Prioritize issues by severity: critical > high > medium > low.
      ```

      Implementation Steps:
      1. Receive webhook when PR is opened
      2. Fetch the diff using GitHub API
      3. Read relevant files for full context
      4. Send to Claude with review prompt
      5. Parse Claude's response into review comments
      6. Post comments back to the PR

      Tools for This Agent:
      - get_pr_diff: Fetch the pull request diff
      - read_file: Get full file contents for context
      - get_file_history: Check recent changes to understand patterns
      - post_review_comment: Add inline comments to the PR

      Handling Large Diffs:
      For PRs with many changes, chunk the review:
      - Group files by directory or concern
      - Review each chunk separately
      - Synthesize a summary at the end

      Reducing False Positives:
      - Include project-specific context (coding standards, known patterns)
      - Allow configuration of severity thresholds
      - Learn from dismissed comments over time

      This agent pattern — webhook trigger, tool-augmented analysis, action output — applies to many CI/CD automation scenarios.
    CONTENT
  },
  {
    title: "Deploying Agents in Production",
    description: "Run your coding agents reliably with proper error handling and observability.",
    position: 5,
    content: <<~CONTENT
      Moving from prototype to production requires attention to reliability, security, and cost management. A production agent needs to handle failures gracefully and provide visibility into its operations.

      Production Considerations:

      Error Handling:
      ```ruby
      def call_claude_with_retry(messages, max_retries: 3)
        retries = 0
        begin
          client.messages.create(model:, messages:, tools:)
        rescue Anthropic::RateLimitError => e
          retries += 1
          raise if retries > max_retries
          sleep(2 ** retries) # Exponential backoff
          retry
        rescue Anthropic::APIError => e
          log_error(e)
          raise AgentError, "Claude API unavailable"
        end
      end
      ```

      Observability:
      - Log every agent invocation with request ID
      - Track token usage for cost monitoring
      - Record tool calls and results for debugging
      - Set up alerts for error rate thresholds
      - Monitor response latency percentiles

      Security:
      - Never include secrets in prompts or logs
      - Validate tool inputs before execution
      - Sandbox command execution (Docker, VMs)
      - Implement rate limiting per user/project
      - Audit log all file modifications

      Cost Management:
      - Cache responses for identical requests
      - Use smaller models for simple tasks
      - Implement token budgets per request
      - Batch similar operations when possible
      - Review usage patterns weekly

      Deployment Architecture:
      ```
      [API Gateway] → [Agent Service] → [Job Queue]
                            ↓                ↓
                      [Claude API]    [Tool Workers]
                            ↓
                      [Result Cache]
      ```

      Background Processing:
      For long-running agent tasks, use background jobs:
      - Solid Queue for job processing
      - Webhook callbacks for completion
      - Progress tracking for UX
      - Timeout handling for stuck jobs

      Testing Agents:
      - Mock Claude responses for unit tests
      - Record/replay for integration tests
      - Separate test API keys with lower limits
      - Test tool execution in isolation

      With these patterns, your agent can handle production traffic reliably while giving you the visibility needed to debug issues and optimize costs.
    CONTENT
  }
]

coding_agents_lessons.each do |attrs|
  Lesson.find_or_create_by!(title: attrs[:title], curriculum_module_id: coding_agents_mod.id) do |l|
    l.description = attrs[:description]
    l.content = attrs[:content]
    l.position = attrs[:position]
  end
end

# Curriculum: The Toolbox (foundational - no prerequisites)
toolbox_mod = CurriculumModule.find_or_create_by!(title: "The Toolbox") do |m|
  m.description = "Master the essential tools every modern developer needs: version control, web frameworks, and package management."
  m.position = 3
end

toolbox_lessons = [
  {
    title: "What's GitHub?",
    description: "Understand version control, Git, and why GitHub is the center of modern software development.",
    position: 1,
    content: <<~CONTENT
      GitHub is where the world's software lives. It's a platform built on Git, the version control system that tracks every change to your code. Understanding GitHub is essential for any developer — it's how teams collaborate, how open source thrives, and how you'll deploy your applications.

      What is Version Control?
      Imagine writing a document and being able to see every edit you've ever made, go back to any previous version, and merge changes from multiple people working simultaneously. That's version control for code.

      Git vs GitHub:
      - Git: The tool that tracks changes locally on your computer
      - GitHub: The cloud platform that hosts Git repositories and adds collaboration features

      Core Git Concepts:
      - Repository (repo): A folder tracked by Git, containing your project and its history
      - Commit: A snapshot of your code at a point in time, with a message describing the change
      - Branch: A parallel version of your code for developing features without affecting the main code
      - Merge: Combining changes from one branch into another
      - Pull Request (PR): A proposal to merge changes, enabling code review before integration

      The GitHub Workflow:
      1. Clone a repository to your local machine
      2. Create a branch for your feature
      3. Make changes and commit them with descriptive messages
      4. Push your branch to GitHub
      5. Open a Pull Request for review
      6. Address feedback, then merge to main
      7. Delete the feature branch

      Essential Git Commands:
      ```bash
      git clone <url>          # Download a repository
      git status               # See what's changed
      git add .                # Stage all changes
      git commit -m "message"  # Save a snapshot
      git push                 # Upload to GitHub
      git pull                 # Download latest changes
      git branch feature-name  # Create a new branch
      git checkout branch-name # Switch branches
      ```

      GitHub Features Beyond Code:
      - Issues: Track bugs, features, and tasks
      - Actions: Automate testing and deployment
      - Projects: Kanban boards for project management
      - Discussions: Community Q&A for your project
      - Pages: Free hosting for static websites

      Why GitHub Matters:
      Your GitHub profile is your developer portfolio. Employers look at your contributions, your code quality, and how you collaborate with others. Start building your presence early — every commit counts.
    CONTENT
  },
  {
    title: "What's Ruby on Rails?",
    description: "Discover why Rails is the framework of choice for startups and how it makes web development joyful.",
    position: 2,
    content: <<~CONTENT
      Ruby on Rails (often just "Rails") is a web application framework that changed how we build software. Created by David Heinemeier Hansson in 2004, Rails introduced conventions that made developers dramatically more productive. GitHub, Shopify, Airbnb, and thousands of startups were built with Rails.

      What is a Web Framework?
      A framework provides structure and pre-built components so you don't start from scratch. Instead of writing code to handle HTTP requests, connect to databases, and render HTML, Rails gives you all of that out of the box.

      The Rails Philosophy:
      - Convention over Configuration: Rails makes decisions for you. File names, folder structures, and database schemas follow patterns. Follow the conventions, and everything "just works."
      - Don't Repeat Yourself (DRY): Write code once, use it everywhere. Rails encourages reusable components and abstractions.
      - Programmer Happiness: Rails is designed to be enjoyable to use. Clear syntax, helpful error messages, and sensible defaults reduce frustration.

      MVC Architecture:
      Rails organizes code into three parts:
      - Model: Your data and business logic (e.g., User, Post, Comment)
      - View: What users see (HTML templates with embedded Ruby)
      - Controller: The traffic cop connecting Models and Views

      A request flows like this:
      1. User visits /posts/1
      2. Router directs to PostsController#show
      3. Controller finds Post with id=1 from the database
      4. Controller renders the show.html.erb view with the post data
      5. HTML is sent back to the user's browser

      Rails Directory Structure:
      ```
      app/
        controllers/    # Handle requests
        models/         # Data and logic
        views/          # HTML templates
      config/
        routes.rb       # URL routing
        database.yml    # Database settings
      db/
        migrate/        # Database changes
        schema.rb       # Current database structure
      ```

      Key Rails Commands:
      ```bash
      rails new myapp           # Create a new application
      rails server              # Start the development server
      rails generate model User # Create a User model
      rails db:migrate          # Apply database changes
      rails console             # Interactive Ruby with your app loaded
      ```

      Why Rails in 2026?
      Rails continues to evolve. Rails 8 introduced Solid Queue, Solid Cache, and Kamal for deployment — making it easier than ever to build and ship production applications without complex infrastructure. The "one-person framework" philosophy means a single developer can build what used to require a team.
    CONTENT
  },
  {
    title: "What's a Ruby Gem?",
    description: "Learn how gems extend Ruby and Rails with pre-built functionality you can add in seconds.",
    position: 3,
    content: <<~CONTENT
      A Ruby gem is a packaged library of code that you can add to your project. Instead of writing everything yourself, you can install a gem and instantly gain new capabilities. Authentication, payment processing, file uploads, API integrations — there's probably a gem for it.

      The Gem Ecosystem:
      RubyGems.org is the official repository where gems are published. With over 180,000 gems available, the Ruby ecosystem is rich with solutions to common problems.

      How Gems Work:
      Gems are distributed as .gem files containing:
      - Ruby code (the actual functionality)
      - A gemspec file (metadata: name, version, dependencies)
      - Documentation and tests

      When you install a gem, Ruby downloads it and makes its code available to require in your project.

      Bundler: Managing Dependencies:
      Bundler is the tool that manages gems in Rails projects. It uses two files:
      - Gemfile: Lists the gems your project needs
      - Gemfile.lock: Records exact versions installed (for reproducibility)

      ```ruby
      # Gemfile example
      source "https://rubygems.org"

      gem "rails", "~> 8.0"
      gem "sqlite3"
      gem "puma"

      group :development do
        gem "debug"
      end
      ```

      Essential Bundler Commands:
      ```bash
      bundle install    # Install gems from Gemfile
      bundle update     # Update gems to latest versions
      bundle add devise # Add a gem to Gemfile and install
      bundle exec rails # Run a command with bundled gems
      ```

      Popular Gems You'll Encounter:
      - devise: User authentication (sign up, login, password reset)
      - sidekiq: Background job processing
      - pundit: Authorization (who can do what)
      - pg: PostgreSQL database adapter
      - rspec-rails: Testing framework
      - rubocop: Code style enforcement
      - pry: Enhanced debugging console

      Anatomy of Using a Gem:
      1. Add to Gemfile: `gem "devise"`
      2. Install: `bundle install`
      3. Run generator (if any): `rails generate devise:install`
      4. Configure as needed
      5. Use in your code

      Creating Your Own Gems:
      As you grow, you'll want to extract reusable code into gems:
      ```bash
      bundle gem my_gem    # Generate gem structure
      # Edit lib/my_gem.rb with your code
      gem build my_gem.gemspec
      gem push my_gem-1.0.0.gem  # Publish to RubyGems.org
      ```

      Version Constraints:
      Gemfiles use version specifiers to control updates:
      - `"~> 2.0"`: Any 2.x version (pessimistic)
      - `">= 1.0"`: Version 1.0 or higher
      - `"= 1.5.3"`: Exactly this version
      - `">= 1.0", "< 2.0"`: Between 1.0 and 2.0

      The pessimistic constraint (`~>`) is most common — it allows patch updates but prevents breaking changes from major versions.

      Gem Security:
      - Only use gems from trusted sources
      - Check gem download counts and recent activity
      - Review the gem's GitHub repository
      - Use `bundle audit` to check for known vulnerabilities
      - Keep gems updated to get security patches
    CONTENT
  }
]

toolbox_lessons.each do |attrs|
  Lesson.find_or_create_by!(title: attrs[:title], curriculum_module_id: toolbox_mod.id) do |l|
    l.description = attrs[:description]
    l.content = attrs[:content]
    l.position = attrs[:position]
  end
end

# Curriculum: Data Exchange (JSON family)
data_exchange_mod = CurriculumModule.find_or_create_by!(title: "Data Exchange") do |m|
  m.description = "Master the protocols that power modern APIs: from JSON basics to semantic web services with JSON-RPC-LD."
  m.position = 4
end

data_exchange_lessons = [
  {
    title: "What's JSON?",
    description: "Learn the universal data format that powers the modern web.",
    position: 1,
    content: <<~CONTENT
      JSON (JavaScript Object Notation) is the lingua franca of web APIs. It's a lightweight, human-readable format for structuring data that has become the standard for data exchange between servers, browsers, and applications.

      Why JSON Won:
      Before JSON, XML dominated data exchange. JSON won because it's simpler, smaller, and maps naturally to data structures in most programming languages. Every modern language has built-in JSON support.

      JSON Syntax:
      JSON has just six data types:
      - Object: `{"key": "value"}` — a collection of key-value pairs
      - Array: `[1, 2, 3]` — an ordered list of values
      - String: `"hello"` — text in double quotes
      - Number: `42` or `3.14` — integers or decimals
      - Boolean: `true` or `false`
      - Null: `null` — represents nothing

      A Real Example:
      ```json
      {
        "user": {
          "id": 123,
          "name": "Alice",
          "email": "alice@example.com",
          "roles": ["admin", "developer"],
          "active": true,
          "lastLogin": null
        }
      }
      ```

      JSON Rules:
      - Keys must be strings in double quotes
      - No trailing commas allowed
      - No comments (unlike JavaScript)
      - Strings must use double quotes (not single)
      - Numbers can't have leading zeros

      Working with JSON in Ruby:
      ```ruby
      require 'json'

      # Parse JSON string to Ruby hash
      data = JSON.parse('{"name": "Alice", "age": 30}')
      puts data["name"]  # => "Alice"

      # Convert Ruby hash to JSON string
      hash = { name: "Bob", scores: [95, 87, 92] }
      json_string = JSON.generate(hash)
      # or: hash.to_json

      # Pretty print for readability
      puts JSON.pretty_generate(hash)
      ```

      JSON in Rails:
      Rails makes JSON easy:
      ```ruby
      # In a controller
      def show
        @user = User.find(params[:id])
        render json: @user
      end

      # Customize the output
      render json: @user, only: [:id, :name, :email]
      render json: @user, include: [:posts, :comments]
      ```

      Common Pitfalls:
      - Dates aren't a JSON type — use ISO 8601 strings: `"2024-01-15T10:30:00Z"`
      - Large numbers may lose precision — use strings for IDs over 53 bits
      - Encoding matters — always use UTF-8
      - Circular references will crash JSON serialization

      JSON is the foundation. Next, we'll see how JSON-RPC builds structured communication on top of it.
    CONTENT
  },
  {
    title: "What's JSON-RPC?",
    description: "Discover the simple protocol for calling remote procedures over HTTP.",
    position: 2,
    content: <<~CONTENT
      JSON-RPC is a protocol for calling functions on remote servers. Instead of designing custom API endpoints for every operation, JSON-RPC provides a standard format: you send a method name and parameters, and you get back a result or error.

      Why JSON-RPC?
      REST APIs require you to map operations to HTTP verbs and URLs. JSON-RPC simplifies this: every request is a POST to a single endpoint, with the operation specified in the request body. This makes APIs easier to design, document, and evolve.

      The Request Format:
      ```json
      {
        "jsonrpc": "2.0",
        "method": "user.create",
        "params": {
          "name": "Alice",
          "email": "alice@example.com"
        },
        "id": 1
      }
      ```

      Required fields:
      - `jsonrpc`: Always "2.0" (the protocol version)
      - `method`: The name of the function to call
      - `id`: A unique identifier to match responses (can be number or string)

      Optional:
      - `params`: Arguments for the method (object or array)

      The Response Format:
      Success:
      ```json
      {
        "jsonrpc": "2.0",
        "result": {
          "id": 123,
          "name": "Alice",
          "created_at": "2024-01-15T10:30:00Z"
        },
        "id": 1
      }
      ```

      Error:
      ```json
      {
        "jsonrpc": "2.0",
        "error": {
          "code": -32602,
          "message": "Invalid params",
          "data": "Email is required"
        },
        "id": 1
      }
      ```

      Standard Error Codes:
      - `-32700`: Parse error (invalid JSON)
      - `-32600`: Invalid request (missing required fields)
      - `-32601`: Method not found
      - `-32602`: Invalid params
      - `-32603`: Internal error
      - `-32000 to -32099`: Server-defined errors

      Batch Requests:
      Send multiple calls in one HTTP request:
      ```json
      [
        {"jsonrpc": "2.0", "method": "user.get", "params": {"id": 1}, "id": 1},
        {"jsonrpc": "2.0", "method": "user.get", "params": {"id": 2}, "id": 2}
      ]
      ```

      Notifications (Fire and Forget):
      Omit the `id` field to indicate you don't need a response:
      ```json
      {
        "jsonrpc": "2.0",
        "method": "log.event",
        "params": {"event": "page_view", "path": "/home"}
      }
      ```

      Implementing in Rails:
      ```ruby
      class RpcController < ApplicationController
        def call
          request_data = JSON.parse(request.body.read)
          result = dispatch(request_data["method"], request_data["params"])

          render json: {
            jsonrpc: "2.0",
            result: result,
            id: request_data["id"]
          }
        rescue => e
          render json: {
            jsonrpc: "2.0",
            error: { code: -32603, message: e.message },
            id: request_data&.dig("id")
          }
        end

        private

        def dispatch(method, params)
          case method
          when "user.create" then User.create!(params)
          when "user.get" then User.find(params["id"])
          else raise "Method not found"
          end
        end
      end
      ```

      JSON-RPC is simple and powerful. But what if you need your data to be self-describing and machine-interpretable? That's where JSON-RPC-LD comes in.
    CONTENT
  },
  {
    title: "What's JSON-RPC-LD?",
    description: "Combine RPC simplicity with semantic web power using linked data.",
    position: 3,
    content: <<~CONTENT
      JSON-RPC-LD extends JSON-RPC with Linked Data capabilities from JSON-LD. It combines the simplicity of remote procedure calls with the semantic richness of the web, making APIs self-describing and interoperable across systems.

      The Problem JSON-RPC-LD Solves:
      Standard APIs require out-of-band documentation. You need to read docs to understand what "user.create" means, what fields are required, and what the response contains. JSON-RPC-LD embeds this meaning directly in the data using standard vocabularies.

      JSON-LD Primer:
      JSON-LD (JSON for Linking Data) adds a `@context` that maps terms to URLs:
      ```json
      {
        "@context": {
          "name": "https://schema.org/name",
          "email": "https://schema.org/email"
        },
        "name": "Alice",
        "email": "alice@example.com"
      }
      ```

      Now any system understanding schema.org knows exactly what "name" and "email" mean — they're globally unique, unambiguous identifiers.

      JSON-RPC-LD Structure:
      ```json
      {
        "@context": "https://magentic.ai/ns/rpc",
        "jsonrpc": "2.0",
        "method": "agent.invoke",
        "params": {
          "@type": "InvokeRequest",
          "agent": "https://magentic.ai/agents/code-reviewer",
          "input": {
            "@type": "CodeReviewInput",
            "repository": "https://github.com/user/repo",
            "pullRequest": 42
          }
        },
        "id": "req-001"
      }
      ```

      Key Concepts:
      - `@context`: Defines the vocabulary for interpreting the data
      - `@type`: Declares what kind of thing this is
      - `@id`: A unique identifier (URL) for this specific resource
      - URLs as values: Link to other resources on the web

      Why This Matters for AI Agents:
      In a world of interoperating AI agents, JSON-RPC-LD enables:
      - Discovery: Agents can find and understand each other's capabilities
      - Composition: Chain services without hardcoded integrations
      - Trust: Verify identities and capabilities through linked credentials
      - Evolution: Add new fields without breaking existing clients

      A Marketplace Example:
      ```json
      {
        "@context": [
          "https://magentic.ai/ns/market",
          {"agent": "https://magentic.ai/ns/agent"}
        ],
        "jsonrpc": "2.0",
        "method": "market.list",
        "params": {
          "@type": "ListingQuery",
          "category": "agent:CodeAssistant",
          "priceMax": {
            "@type": "MonetaryAmount",
            "currency": "USD",
            "value": 100
          }
        },
        "id": "search-123"
      }
      ```

      The response links to agent profiles, pricing, and capability descriptions — all machine-readable:
      ```json
      {
        "@context": "https://magentic.ai/ns/market",
        "jsonrpc": "2.0",
        "result": {
          "@type": "ListingResults",
          "items": [
            {
              "@id": "https://magentic.ai/agents/code-owl",
              "@type": "AgentListing",
              "name": "Code Owl",
              "capabilities": ["code-review", "refactoring"],
              "pricing": {
                "@type": "PricingPlan",
                "model": "per-request",
                "price": {"value": 0.05, "currency": "USD"}
              }
            }
          ]
        },
        "id": "search-123"
      }
      ```

      Implementing JSON-RPC-LD:
      1. Define your vocabulary (context) at a stable URL
      2. Use `@type` for all objects to enable polymorphism
      3. Use `@id` for resources that can be referenced
      4. Validate requests against JSON-LD schemas
      5. Return contexts in responses for self-description

      The Magentic Market uses JSON-RPC-LD as its wire protocol, enabling AI agents to discover, negotiate with, and invoke each other in a decentralized marketplace. This is the foundation of the agentic web.
    CONTENT
  }
]

data_exchange_lessons.each do |attrs|
  Lesson.find_or_create_by!(title: attrs[:title], curriculum_module_id: data_exchange_mod.id) do |l|
    l.description = attrs[:description]
    l.content = attrs[:content]
    l.position = attrs[:position]
  end
end

# Curriculum: Building the Agentic Web (requires all previous curricula)
swarm_pod_module = CurriculumModule.find_by!(title: "SwarmPod Fundamentals")
coding_agents_module = CurriculumModule.find_by!(title: "Coding Agents")
toolbox_module = CurriculumModule.find_by!(title: "The Toolbox")
data_exchange_module = CurriculumModule.find_by!(title: "Data Exchange")

agentic_web_mod = CurriculumModule.find_or_create_by!(title: "Building the Agentic Web") do |m|
  m.description = "Capstone: Combine everything you've learned to build and deploy AI agents in the Magentic Market ecosystem."
  m.position = 5
end

# Set up multiple prerequisites
[swarm_pod_module, coding_agents_module, toolbox_module, data_exchange_module].each do |prereq|
  ModulePrerequisite.find_or_create_by!(
    curriculum_module: agentic_web_mod,
    prerequisite_module: prereq
  )
end

agentic_web_lessons = [
  {
    title: "The Magentic Market Architecture",
    description: "Understand how decentralized agent marketplaces work and where your agent fits.",
    position: 1,
    content: <<~CONTENT
      The Magentic Market is a decentralized marketplace where AI agents offer and consume services. Unlike traditional APIs with fixed endpoints, agents discover each other dynamically, negotiate terms, and execute transactions — all using the protocols you've learned.

      The Vision:
      Imagine a web where AI agents are first-class citizens. An agent that reviews code can find and hire a security-scanning agent. A data-processing agent can discover a visualization agent. Services compose automatically based on capabilities, not hardcoded integrations.

      Architecture Overview:

      <svg viewBox="0 0 600 400" xmlns="http://www.w3.org/2000/svg" style="max-width: 100%; height: auto; background: #1e293b; border-radius: 12px;">
        <!-- Title -->
        <text x="300" y="35" text-anchor="middle" fill="#8b5cf6" font-size="18" font-weight="bold">Magentic Market</text>

        <!-- Core Services Row -->
        <g transform="translate(50, 60)">
          <!-- magentic_id -->
          <rect x="0" y="0" width="140" height="60" rx="8" fill="#3b82f6" opacity="0.2" stroke="#3b82f6" stroke-width="2"/>
          <text x="70" y="28" text-anchor="middle" fill="#3b82f6" font-size="12" font-weight="bold">magentic_id</text>
          <text x="70" y="45" text-anchor="middle" fill="#94a3b8" font-size="10">Identity</text>

          <!-- magentic_mail -->
          <rect x="170" y="0" width="140" height="60" rx="8" fill="#10b981" opacity="0.2" stroke="#10b981" stroke-width="2"/>
          <text x="240" y="28" text-anchor="middle" fill="#10b981" font-size="12" font-weight="bold">magentic_mail</text>
          <text x="240" y="45" text-anchor="middle" fill="#94a3b8" font-size="10">Messaging</text>

          <!-- magentic_host -->
          <rect x="340" y="0" width="140" height="60" rx="8" fill="#f59e0b" opacity="0.2" stroke="#f59e0b" stroke-width="2"/>
          <text x="410" y="28" text-anchor="middle" fill="#f59e0b" font-size="12" font-weight="bold">magentic_host</text>
          <text x="410" y="45" text-anchor="middle" fill="#94a3b8" font-size="10">Hosting</text>
        </g>

        <!-- Connection lines from services to protocol -->
        <line x1="120" y1="120" x2="300" y2="180" stroke="#475569" stroke-width="2"/>
        <line x1="290" y1="120" x2="300" y2="180" stroke="#475569" stroke-width="2"/>
        <line x1="460" y1="120" x2="300" y2="180" stroke="#475569" stroke-width="2"/>

        <!-- json_rpc_ld Protocol -->
        <g transform="translate(200, 180)">
          <rect x="0" y="0" width="200" height="60" rx="8" fill="#8b5cf6" opacity="0.2" stroke="#8b5cf6" stroke-width="2"/>
          <text x="100" y="28" text-anchor="middle" fill="#8b5cf6" font-size="12" font-weight="bold">json_rpc_ld</text>
          <text x="100" y="45" text-anchor="middle" fill="#94a3b8" font-size="10">Protocol Layer</text>
        </g>

        <!-- Connection lines from protocol to agents -->
        <line x1="300" y1="240" x2="120" y2="290" stroke="#475569" stroke-width="2"/>
        <line x1="300" y1="240" x2="300" y2="290" stroke="#475569" stroke-width="2"/>
        <line x1="300" y1="240" x2="480" y2="290" stroke="#475569" stroke-width="2"/>

        <!-- Agents Row -->
        <g transform="translate(50, 290)">
          <!-- Agent A -->
          <rect x="0" y="0" width="140" height="60" rx="8" fill="#0f172a" stroke="#475569" stroke-width="2"/>
          <circle cx="25" cy="30" r="12" fill="#3b82f6"/>
          <text x="80" y="28" text-anchor="middle" fill="#e2e8f0" font-size="12" font-weight="bold">Agent A</text>
          <text x="80" y="45" text-anchor="middle" fill="#64748b" font-size="10">Code Review</text>

          <!-- Agent B -->
          <rect x="170" y="0" width="140" height="60" rx="8" fill="#0f172a" stroke="#475569" stroke-width="2"/>
          <circle cx="195" cy="30" r="12" fill="#10b981"/>
          <text x="250" y="28" text-anchor="middle" fill="#e2e8f0" font-size="12" font-weight="bold">Agent B</text>
          <text x="250" y="45" text-anchor="middle" fill="#64748b" font-size="10">Security Scan</text>

          <!-- Agent C -->
          <rect x="340" y="0" width="140" height="60" rx="8" fill="#0f172a" stroke="#475569" stroke-width="2"/>
          <circle cx="365" cy="30" r="12" fill="#f59e0b"/>
          <text x="420" y="28" text-anchor="middle" fill="#e2e8f0" font-size="12" font-weight="bold">Agent C</text>
          <text x="420" y="45" text-anchor="middle" fill="#64748b" font-size="10">Documentation</text>
        </g>

        <!-- Legend -->
        <g transform="translate(50, 370)">
          <text x="0" y="0" fill="#64748b" font-size="10">Agents discover and invoke each other via JSON-RPC-LD</text>
        </g>
      </svg>

      Core Services:
      - **magentic_id**: Identity verification and WebFinger discovery
      - **magentic_mail**: Secure messaging between agents
      - **magentic_host**: Agent hosting and deployment
      - **magentic_github**: Source code repository hosting
      - **magentic_rubygems**: Ruby gem distribution
      - **json_rpc_ld**: Protocol service for semantic RPC
      - **at_context**: JSON-LD context definitions

      How Agents Find Each Other:
      1. Agent publishes capabilities to the registry
      2. Client queries registry for agents matching needs
      3. Registry returns agent profiles with endpoints
      4. Client verifies identity via magentic_id
      5. Client invokes agent via JSON-RPC-LD

      The Trust Layer:
      Every agent has a verified identity. When Agent A calls Agent B:
      - A's identity is verified via magentic_id
      - B can check A's reputation and history
      - Transactions are logged for accountability
      - Disputes can be resolved with audit trails

      Your agent will plug into this ecosystem, offering services to other agents while potentially consuming services from them.
    CONTENT
  },
  {
    title: "Creating Your Agent Profile",
    description: "Define your agent's identity, capabilities, and pricing in the marketplace.",
    position: 2,
    content: <<~CONTENT
      Before your agent can participate in the marketplace, it needs an identity. This lesson walks through creating and registering your agent's profile using the Magentic ID service.

      Agent Identity Components:
      ```json
      {
        "@context": "https://magentic.ai/ns/agent",
        "@id": "https://magentic.ai/agents/my-code-helper",
        "@type": "Agent",
        "name": "Code Helper",
        "description": "AI assistant for code review and refactoring",
        "publisher": {
          "@type": "Organization",
          "name": "My Company",
          "url": "https://mycompany.com"
        },
        "version": "1.0.0",
        "capabilities": [
          {
            "@type": "Capability",
            "name": "code-review",
            "description": "Reviews pull requests for bugs and style issues",
            "inputSchema": "https://magentic.ai/schemas/code-review-input",
            "outputSchema": "https://magentic.ai/schemas/code-review-output"
          }
        ],
        "pricing": {
          "@type": "PricingPlan",
          "model": "per-request",
          "basePrice": {"value": 0.10, "currency": "USD"}
        },
        "endpoint": "https://my-agent.example.com/rpc"
      }
      ```

      Key Fields Explained:
      - `@id`: Your agent's unique URL (becomes its identity)
      - `capabilities`: What your agent can do (discoverable by clients)
      - `inputSchema`/`outputSchema`: JSON Schema for request/response validation
      - `pricing`: How you charge for services
      - `endpoint`: Where to send JSON-RPC-LD requests

      Registration Flow:
      ```ruby
      # 1. Generate keypair for signing
      keypair = OpenSSL::PKey::Ed25519.generate

      # 2. Create agent profile
      profile = {
        "@context": "https://magentic.ai/ns/agent",
        "@type": "Agent",
        name: "My Agent",
        # ... other fields
      }

      # 3. Sign the profile
      signature = keypair.sign(profile.to_json)

      # 4. Register with magentic_id
      client = MagenticId::Client.new
      client.register_agent(
        profile: profile,
        signature: signature,
        public_key: keypair.public_key
      )
      ```

      WebFinger Discovery:
      Once registered, your agent is discoverable via WebFinger:
      ```
      GET /.well-known/webfinger?resource=acct:my-code-helper@magentic.ai

      {
        "subject": "acct:my-code-helper@magentic.ai",
        "links": [
          {
            "rel": "https://magentic.ai/ns/agent-profile",
            "href": "https://magentic.ai/agents/my-code-helper"
          }
        ]
      }
      ```

      Profile Updates:
      Your agent evolves. Update capabilities, pricing, or endpoints:
      ```ruby
      client.update_agent(
        agent_id: "my-code-helper",
        changes: { pricing: new_pricing },
        signature: sign_changes(keypair, changes)
      )
      ```

      Best Practices:
      - Use semantic versioning for your agent
      - Document capabilities thoroughly — they're your API contract
      - Start with simple pricing, adjust based on usage
      - Keep your signing key secure (use Rails credentials)
    CONTENT
  },
  {
    title: "Implementing Agent Endpoints",
    description: "Build the JSON-RPC-LD handlers that power your agent's capabilities.",
    position: 3,
    content: <<~CONTENT
      With your agent registered, it's time to implement the endpoints that handle incoming requests. You'll build a Rails controller that processes JSON-RPC-LD, validates inputs, calls Claude, and returns structured responses.

      The RPC Controller:
      ```ruby
      class AgentRpcController < ApplicationController
        skip_before_action :verify_authenticity_token

        def invoke
          request_data = parse_jsonrpc_ld(request.body.read)

          # Validate the request
          validate_request!(request_data)

          # Verify caller identity
          caller = verify_caller(request)

          # Dispatch to capability handler
          result = dispatch(
            request_data["method"],
            request_data["params"],
            caller: caller
          )

          render json: success_response(result, request_data["id"])
        rescue JsonRpcError => e
          render json: error_response(e, request_data&.dig("id"))
        end

        private

        def dispatch(method, params, caller:)
          case method
          when "codeReview.analyze"
            CodeReviewCapability.analyze(params, caller: caller)
          when "codeReview.suggest"
            CodeReviewCapability.suggest(params, caller: caller)
          else
            raise MethodNotFoundError, method
          end
        end
      end
      ```

      Capability Implementation:
      ```ruby
      class CodeReviewCapability
        def self.analyze(params, caller:)
          # Validate input against schema
          validate_input!(params, schema: INPUT_SCHEMA)

          # Fetch the code to review
          diff = fetch_diff(params["repository"], params["pullRequest"])

          # Call Claude for analysis
          analysis = claude_client.analyze_code(
            diff: diff,
            focus: params["focus"] || "all"
          )

          # Structure the response
          {
            "@type" => "CodeReviewResult",
            "summary" => analysis.summary,
            "issues" => analysis.issues.map { |i| format_issue(i) },
            "score" => analysis.quality_score
          }
        end
      end
      ```

      Input Validation with JSON Schema:
      ```ruby
      INPUT_SCHEMA = {
        "type" => "object",
        "required" => ["repository", "pullRequest"],
        "properties" => {
          "repository" => {
            "type" => "string",
            "format" => "uri"
          },
          "pullRequest" => {
            "type" => "integer",
            "minimum" => 1
          },
          "focus" => {
            "type" => "string",
            "enum" => ["security", "performance", "style", "all"]
          }
        }
      }

      def validate_input!(params, schema:)
        errors = JSON::Validator.fully_validate(schema, params)
        raise InvalidParamsError, errors.join(", ") if errors.any?
      end
      ```

      Caller Verification:
      ```ruby
      def verify_caller(request)
        # Extract signature from header
        signature = request.headers["X-Magentic-Signature"]
        caller_id = request.headers["X-Magentic-Caller"]

        # Fetch caller's public key from magentic_id
        caller_profile = MagenticId::Client.new.get_agent(caller_id)

        # Verify signature
        unless verify_signature(request.body, signature, caller_profile.public_key)
          raise AuthenticationError, "Invalid signature"
        end

        caller_profile
      end
      ```

      Response Formatting:
      ```ruby
      def success_response(result, id)
        {
          "@context" => "https://magentic.ai/ns/rpc",
          "jsonrpc" => "2.0",
          "result" => result,
          "id" => id
        }
      end

      def error_response(error, id)
        {
          "@context" => "https://magentic.ai/ns/rpc",
          "jsonrpc" => "2.0",
          "error" => {
            "code" => error.code,
            "message" => error.message,
            "data" => error.data
          },
          "id" => id
        }
      end
      ```

      Testing Your Endpoint:
      ```bash
      curl -X POST https://my-agent.example.com/rpc \\
        -H "Content-Type: application/json" \\
        -H "X-Magentic-Caller: test-client" \\
        -H "X-Magentic-Signature: ..." \\
        -d '{
          "@context": "https://magentic.ai/ns/rpc",
          "jsonrpc": "2.0",
          "method": "codeReview.analyze",
          "params": {
            "repository": "https://github.com/user/repo",
            "pullRequest": 42
          },
          "id": "req-001"
        }'
      ```
    CONTENT
  },
  {
    title: "Deploying to Magentic Host",
    description: "Ship your agent to production using Kamal and the Magentic hosting infrastructure.",
    position: 4,
    content: <<~CONTENT
      Your agent is built and tested. Now it's time to deploy it to the Magentic Host service, making it available to the entire marketplace.

      Deployment Options:
      1. **Magentic Host** (managed): We handle infrastructure, you deploy with Kamal
      2. **Self-hosted**: Run on your own servers, register endpoint with magentic_id
      3. **Hybrid**: Host compute yourself, use Magentic for discovery/identity

      This lesson focuses on Magentic Host deployment.

      Preparing Your Agent:
      ```yaml
      # config/deploy.yml
      service: my-code-helper
      image: my-code-helper

      servers:
        web:
          hosts:
            - magentic-host-1.example.com
          labels:
            magentic.agent: my-code-helper
            magentic.version: 1.0.0

      registry:
        server: ghcr.io
        username: <%= ENV["GITHUB_USERNAME"] %>
        password: <%= ENV["GITHUB_TOKEN"] %>

      env:
        clear:
          RAILS_ENV: production
          MAGENTIC_AGENT_ID: my-code-helper
        secret:
          - RAILS_MASTER_KEY
          - ANTHROPIC_API_KEY
          - MAGENTIC_SIGNING_KEY

      healthcheck:
        path: /up
        interval: 10s
      ```

      The Deployment Flow:
      ```bash
      # 1. Build and push Docker image
      kamal build push

      # 2. Deploy to Magentic Host
      kamal deploy

      # 3. Verify deployment
      kamal app details
      ```

      Automated Deployment with GitHub Actions:
      ```yaml
      # .github/workflows/deploy.yml
      name: Deploy Agent

      on:
        push:
          branches: [main]

      jobs:
        deploy:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4

            - name: Set up Ruby
              uses: ruby/setup-ruby@v1
              with:
                bundler-cache: true

            - name: Run tests
              run: bin/rails test

            - name: Deploy with Kamal
              run: kamal deploy
              env:
                KAMAL_REGISTRY_PASSWORD: ${{ secrets.GITHUB_TOKEN }}
                RAILS_MASTER_KEY: ${{ secrets.RAILS_MASTER_KEY }}
      ```

      Post-Deployment Registration:
      After deployment, update your agent's endpoint in magentic_id:
      ```ruby
      # lib/tasks/magentic.rake
      namespace :magentic do
        task register: :environment do
          client = MagenticId::Client.new

          client.update_agent(
            agent_id: ENV["MAGENTIC_AGENT_ID"],
            changes: {
              endpoint: "https://#{ENV['MAGENTIC_HOST']}/rpc",
              status: "active"
            }
          )

          puts "Agent registered and active!"
        end
      end
      ```

      Monitoring Your Agent:
      ```ruby
      # config/initializers/instrumentation.rb
      ActiveSupport::Notifications.subscribe("agent.invoke") do |event|
        Rails.logger.info({
          event: "agent_invoke",
          method: event.payload[:method],
          caller: event.payload[:caller],
          duration_ms: event.duration,
          success: event.payload[:success]
        }.to_json)
      end
      ```

      Scaling Considerations:
      - Use Solid Queue for background processing of long requests
      - Implement request timeouts (Claude calls can be slow)
      - Cache frequently-requested data (repository metadata, etc.)
      - Monitor token usage to control costs

      Your agent is now live in the Magentic Market, discoverable by other agents and ready to serve requests!
    CONTENT
  },
  {
    title: "Composing Agent Services",
    description: "Learn to build agents that discover and use other agents' capabilities.",
    position: 5,
    content: <<~CONTENT
      The true power of the agentic web emerges when agents collaborate. Your agent can discover, negotiate with, and invoke other agents to accomplish complex tasks. This lesson shows you how.

      The Agent Client:
      ```ruby
      class MagenticAgent::Client
        def initialize(signing_key:)
          @signing_key = signing_key
          @id_client = MagenticId::Client.new
        end

        def discover(capability:, constraints: {})
          @id_client.search_agents(
            capability: capability,
            max_price: constraints[:max_price],
            min_reputation: constraints[:min_reputation]
          )
        end

        def invoke(agent_id:, method:, params:)
          agent = @id_client.get_agent(agent_id)

          request = build_request(method, params)
          signature = sign_request(request)

          response = HTTP
            .headers(
              "Content-Type" => "application/json",
              "X-Magentic-Caller" => my_agent_id,
              "X-Magentic-Signature" => signature
            )
            .post(agent.endpoint, json: request)

          parse_response(response)
        end
      end
      ```

      Dynamic Service Composition:
      ```ruby
      class ComprehensiveReviewAgent
        def review(repository:, pull_request:)
          client = MagenticAgent::Client.new(signing_key: SIGNING_KEY)

          # Discover specialized reviewers
          security_agents = client.discover(
            capability: "security-scan",
            constraints: { max_price: 0.50 }
          )

          performance_agents = client.discover(
            capability: "performance-analysis",
            constraints: { max_price: 0.30 }
          )

          # Invoke in parallel
          results = Parallel.map([
            -> { client.invoke(security_agents.first.id, "scan", { repo: repository, pr: pull_request }) },
            -> { client.invoke(performance_agents.first.id, "analyze", { repo: repository, pr: pull_request }) },
            -> { my_style_review(repository, pull_request) }
          ]) { |task| task.call }

          # Combine results
          {
            security: results[0],
            performance: results[1],
            style: results[2],
            summary: synthesize(results)
          }
        end
      end
      ```

      Handling Failures Gracefully:
      ```ruby
      def invoke_with_fallback(capability:, method:, params:)
        agents = client.discover(capability: capability)

        agents.each do |agent|
          begin
            return client.invoke(
              agent_id: agent.id,
              method: method,
              params: params
            )
          rescue MagenticAgent::Error => e
            Rails.logger.warn "Agent \#{agent.id} failed: \#{e.message}"
            next
          end
        end

        raise NoAvailableAgentError, "All agents for \#{capability} failed"
      end
      ```

      Cost Management:
      ```ruby
      class CostAwareInvoker
        def initialize(budget:)
          @budget = budget
          @spent = 0
        end

        def invoke(agent:, method:, params:)
          estimated_cost = agent.pricing.estimate(method, params)

          if @spent + estimated_cost > @budget
            raise BudgetExceededError, "Would exceed budget: $\#{@budget}"
          end

          result = client.invoke(agent.id, method, params)
          @spent += result.metadata[:actual_cost]

          result
        end
      end
      ```

      Building a Pipeline:
      ```ruby
      class AgentPipeline
        def initialize
          @steps = []
        end

        def add_step(capability:, method:, transform: nil)
          @steps << { capability:, method:, transform: }
          self
        end

        def execute(initial_input)
          @steps.reduce(initial_input) do |input, step|
            agent = discover_best_agent(step[:capability])
            result = invoke(agent, step[:method], input)
            step[:transform] ? step[:transform].call(result) : result
          end
        end
      end

      # Usage
      pipeline = AgentPipeline.new
        .add_step(capability: "code-analysis", method: "extract_functions")
        .add_step(capability: "documentation", method: "generate_docs")
        .add_step(capability: "formatting", method: "format_markdown")

      docs = pipeline.execute(source_code: code)
      ```

      You've now learned to build agents that are both providers and consumers of services in the Magentic Market. This is the foundation of the agentic web — autonomous services that discover, trust, and collaborate with each other to accomplish tasks no single agent could handle alone.

      Welcome to the future of software.
    CONTENT
  }
]

agentic_web_lessons.each do |attrs|
  Lesson.find_or_create_by!(title: attrs[:title], curriculum_module_id: agentic_web_mod.id) do |l|
    l.description = attrs[:description]
    l.content = attrs[:content]
    l.position = attrs[:position]
  end
end

puts "Seeded #{Lesson.count} lessons in #{CurriculumModule.count} module(s)"

# Hackathons
hackathons = [
  # North America
  { name: "HackMIT 2026", start_date: "2026-09-19", end_date: "2026-09-20", location: "MIT, Cambridge, MA", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "$50,000", registration_link: "https://hackmit.org", source: "MLH", description: "MIT's premier hackathon bringing together 1,000+ hackers to build innovative projects in 24 hours.", country: "USA", region: "North America" },
  { name: "PennApps XXIV", start_date: "2026-09-12", end_date: "2026-09-14", location: "UPenn, Philadelphia, PA", location_type: "In Person", theme: "Open Innovation", prize_pool: "$30,000", registration_link: "https://pennapps.com", source: "MLH", description: "One of the oldest college hackathons in the nation. Build anything you can dream up.", country: "USA", region: "North America" },
  { name: "TreeHacks 2026", start_date: "2026-02-14", end_date: "2026-02-16", location: "Stanford University, CA", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "$40,000", registration_link: "https://treehacks.com", source: "MLH", description: "Stanford's annual hackathon focused on projects that make a positive impact on the world.", country: "USA", region: "North America" },
  { name: "CalHacks 11.0", start_date: "2026-10-17", end_date: "2026-10-19", location: "UC Berkeley, CA", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "$75,000", registration_link: "https://calhacks.io", source: "MLH", description: "The world's largest collegiate hackathon, hosted at UC Berkeley.", country: "USA", region: "North America" },
  { name: "HackNY 2026", start_date: "2026-04-11", end_date: "2026-04-12", location: "New York, NY", location_type: "In Person", theme: "Civic Tech", prize_pool: "$15,000", registration_link: "https://hackny.org", source: "MLH", description: "Build technology that serves the people of New York City.", country: "USA", region: "North America" },
  { name: "Hack the North 2026", start_date: "2026-09-26", end_date: "2026-09-28", location: "University of Waterloo, Ontario", location_type: "In Person", theme: "Open Innovation", prize_pool: "$50,000 CAD", registration_link: "https://hackthenorth.com", source: "MLH", description: "Canada's biggest hackathon, bringing together 1,500+ hackers from around the world.", country: "Canada", region: "North America" },
  { name: "ETHGlobal New York", start_date: "2026-06-20", end_date: "2026-06-22", location: "New York, NY", location_type: "In Person", theme: "Web3 & Blockchain", prize_pool: "$500,000", registration_link: "https://ethglobal.com", source: "Devpost", description: "Build the future of decentralized applications at the world's leading Ethereum hackathon.", country: "USA", region: "North America" },
  { name: "FinTech Disrupt", start_date: "2026-08-15", end_date: "2026-08-17", location: "San Francisco, CA", location_type: "In Person", theme: "FinTech", prize_pool: "$60,000", registration_link: "https://devpost.com/hackathons", source: "Devpost", description: "Reimagine financial services with cutting-edge technology. Sponsored by leading banks and payment providers.", country: "USA", region: "North America" },
  { name: "RubyConf Hack Day", start_date: "2026-11-15", end_date: "2026-11-15", location: "Chicago, IL", location_type: "In Person", theme: "Open Source", prize_pool: "Swag & Recognition", registration_link: "https://rubyconf.org", source: "RubyConf", description: "A single-day hack event at RubyConf, focused on contributing to Ruby open source projects.", country: "USA", region: "North America" },
  { name: "RailsConf Open Source Sprint", start_date: "2026-05-06", end_date: "2026-05-07", location: "Detroit, MI", location_type: "In Person", theme: "Open Source", prize_pool: "Community Recognition", registration_link: "https://railsconf.org", source: "RubyConf", description: "Contribute to Rails and the Ruby ecosystem at this community-driven open source sprint.", country: "USA", region: "North America" },
  { name: "IoT World Hack", start_date: "2026-06-05", end_date: "2026-06-07", location: "Austin, TX", location_type: "Hybrid", theme: "IoT & Hardware", prize_pool: "$35,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Connect the physical and digital worlds. Build IoT projects that push boundaries.", country: "USA", region: "North America" },
  { name: "Health Tech Sprint", start_date: "2026-08-22", end_date: "2026-08-24", location: "Boston, MA", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "$45,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Innovate in healthcare technology. Build solutions that improve patient outcomes and healthcare delivery.", country: "USA", region: "North America" },
  { name: "HackMTY 2026", start_date: "2026-08-01", end_date: "2026-08-02", location: "Monterrey, Nuevo Leon", location_type: "In Person", theme: "Open Innovation", prize_pool: "$20,000", registration_link: "https://hackmty.com", source: "Hackathon.com", description: "Mexico's largest hackathon, bringing together Latin American developers to build innovative solutions.", country: "Mexico", region: "North America" },

  # Europe
  { name: "Rails World Hackathon", start_date: "2026-10-08", end_date: "2026-10-09", location: "Amsterdam, Netherlands", location_type: "In Person", theme: "Web Development", prize_pool: "$10,000", registration_link: "https://rubyonrails.org/world", source: "RubyConf", description: "Build something amazing with Rails at the official Rails World conference hackathon.", country: "Netherlands", region: "Europe" },
  { name: "Junction 2026", start_date: "2026-11-14", end_date: "2026-11-16", location: "Helsinki, Finland", location_type: "In Person", theme: "Open Innovation", prize_pool: "EUR 20,000", registration_link: "https://hackjunction.com", source: "Hackathon.com", description: "Europe's leading hackathon, bringing together 1,500 developers in Helsinki.", country: "Finland", region: "Europe" },
  { name: "HackZurich 2026", start_date: "2026-10-24", end_date: "2026-10-25", location: "Zurich, Switzerland", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "CHF 30,000", registration_link: "https://hackzurich.com", source: "Hackathon.com", description: "Europe's largest hackathon, hosted annually in Zurich with top-tier corporate sponsors.", country: "Switzerland", region: "Europe" },
  { name: "HackUPC 2026", start_date: "2026-05-09", end_date: "2026-05-11", location: "Barcelona, Spain", location_type: "In Person", theme: "Open Innovation", prize_pool: "EUR 10,000", registration_link: "https://hackupc.com", source: "MLH", description: "Spain's biggest student hackathon, held at the Universitat Politecnica de Catalunya.", country: "Spain", region: "Europe" },
  { name: "Hack Cambridge 2026", start_date: "2026-01-24", end_date: "2026-01-25", location: "Cambridge, England", location_type: "In Person", theme: "Open Innovation", prize_pool: "GBP 5,000", registration_link: "https://hackcambridge.com", source: "MLH", description: "The University of Cambridge's annual hackathon, attracting top talent from across the UK.", country: "United Kingdom", region: "Europe" },
  { name: "LauzHack 2026", start_date: "2026-11-22", end_date: "2026-11-23", location: "Lausanne, Switzerland", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "CHF 10,000", registration_link: "https://lauzhack.com", source: "Hackathon.com", description: "EPFL's hackathon focused on sustainability and social good, nestled on the shores of Lake Geneva.", country: "Switzerland", region: "Europe" },
  { name: "BrumHack 2026", start_date: "2026-03-14", end_date: "2026-03-15", location: "Birmingham, England", location_type: "In Person", theme: "Open Innovation", prize_pool: "GBP 3,000", registration_link: "https://brumhack.co.uk", source: "MLH", description: "Birmingham's community-driven hackathon, open to students and professionals alike.", country: "United Kingdom", region: "Europe" },
  { name: "START Hack 2026", start_date: "2026-03-21", end_date: "2026-03-22", location: "St. Gallen, Switzerland", location_type: "In Person", theme: "FinTech", prize_pool: "CHF 20,000", registration_link: "https://starthack.eu", source: "Hackathon.com", description: "A premier European hackathon focused on fintech innovation, hosted by the University of St. Gallen.", country: "Switzerland", region: "Europe" },
  { name: "HackaTUM 2026", start_date: "2026-11-21", end_date: "2026-11-23", location: "Munich, Germany", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "EUR 15,000", registration_link: "https://hack.tum.de", source: "Hackathon.com", description: "Technical University of Munich's hackathon, one of Germany's largest with 800+ participants.", country: "Germany", region: "Europe" },

  # Asia
  { name: "AngelHack Singapore", start_date: "2026-06-14", end_date: "2026-06-15", location: "Singapore", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "$25,000", registration_link: "https://angelhack.com", source: "Hackathon.com", description: "Southeast Asia's premier hackathon, bridging startups and developers in the heart of Singapore.", country: "Singapore", region: "Asia" },
  { name: "Smart India Hackathon 2026", start_date: "2026-08-08", end_date: "2026-08-09", location: "Multiple Cities, India", location_type: "In Person", theme: "Civic Tech", prize_pool: "INR 50,00,000", registration_link: "https://sih.gov.in", source: "Hackathon.com", description: "India's largest open innovation platform, with thousands of students solving government challenges.", country: "India", region: "Asia" },
  { name: "Hack Asia 2026", start_date: "2026-07-18", end_date: "2026-07-20", location: "Tokyo, Japan", location_type: "In Person", theme: "Open Innovation", prize_pool: "$30,000", registration_link: "https://hackasia.io", source: "Hackathon.com", description: "A pan-Asian hackathon bringing together developers from Japan, Korea, and Southeast Asia.", country: "Japan", region: "Asia" },
  { name: "ETHIndia 2026", start_date: "2026-12-06", end_date: "2026-12-08", location: "Bangalore, India", location_type: "In Person", theme: "Web3 & Blockchain", prize_pool: "$100,000", registration_link: "https://ethindia.co", source: "Devpost", description: "Asia's largest Ethereum hackathon, part of the ETHGlobal circuit, held in India's tech capital.", country: "India", region: "Asia" },
  { name: "KAIST Hackathon", start_date: "2026-09-13", end_date: "2026-09-14", location: "Daejeon, South Korea", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "KRW 10,000,000", registration_link: "https://kaist.ac.kr", source: "Hackathon.com", description: "South Korea's top university hosts a hackathon focused on AI and deep learning applications.", country: "South Korea", region: "Asia" },

  # Latin America
  { name: "Hackathon Brasil 2026", start_date: "2026-07-25", end_date: "2026-07-27", location: "Sao Paulo, Brazil", location_type: "In Person", theme: "FinTech", prize_pool: "R$ 50,000", registration_link: "https://hackathonbrasil.com.br", source: "Hackathon.com", description: "Brazil's biggest hackathon, focused on fintech innovation in Latin America's largest economy.", country: "Brazil", region: "Latin America" },
  { name: "Nuvemshop Hack", start_date: "2026-06-28", end_date: "2026-06-29", location: "Buenos Aires, Argentina", location_type: "In Person", theme: "Open Innovation", prize_pool: "$15,000", registration_link: "https://nuvemshop.com.br", source: "Hackathon.com", description: "An e-commerce-focused hackathon hosted by Latin America's leading e-commerce platform.", country: "Argentina", region: "Latin America" },
  { name: "HackBogota 2026", start_date: "2026-09-20", end_date: "2026-09-21", location: "Bogota, Colombia", location_type: "In Person", theme: "Social Impact", prize_pool: "$10,000", registration_link: "https://hackbogota.com", source: "Hackathon.com", description: "Colombia's civic tech hackathon, building solutions for urban challenges in South America.", country: "Colombia", region: "Latin America" },

  # Africa
  { name: "Africa Hackathon 2026", start_date: "2026-10-10", end_date: "2026-10-12", location: "Nairobi, Kenya", location_type: "Hybrid", theme: "Social Impact", prize_pool: "$20,000", registration_link: "https://africahackathon.com", source: "Hackathon.com", description: "Pan-African hackathon tackling challenges in agriculture, health, and financial inclusion.", country: "Kenya", region: "Africa" },
  { name: "Hack4Africa", start_date: "2026-04-18", end_date: "2026-04-19", location: "Lagos, Nigeria", location_type: "In Person", theme: "FinTech", prize_pool: "$15,000", registration_link: "https://hack4africa.org", source: "Hackathon.com", description: "West Africa's premier fintech hackathon, building payment and banking solutions for the unbanked.", country: "Nigeria", region: "Africa" },
  { name: "Cape Town Innovation Hack", start_date: "2026-08-29", end_date: "2026-08-30", location: "Cape Town, South Africa", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "ZAR 100,000", registration_link: "https://capetownhack.co.za", source: "Hackathon.com", description: "South Africa's health-tech hackathon, focused on solutions for public health challenges.", country: "South Africa", region: "Africa" },

  # Oceania
  { name: "GovHack 2026", start_date: "2026-08-07", end_date: "2026-08-09", location: "Multiple Cities, Australia", location_type: "Hybrid", theme: "Civic Tech", prize_pool: "AUD 20,000", registration_link: "https://govhack.org", source: "Hackathon.com", description: "Australia's largest open data hackathon, with satellite events across the country and New Zealand.", country: "Australia", region: "Oceania" },
  { name: "Hackathon NZ 2026", start_date: "2026-09-06", end_date: "2026-09-07", location: "Auckland, New Zealand", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "NZD 10,000", registration_link: "https://hackathon.nz", source: "Hackathon.com", description: "New Zealand's community hackathon, focused on sustainability and environmental tech.", country: "New Zealand", region: "Oceania" },
  { name: "UNSW ProgComp", start_date: "2026-10-31", end_date: "2026-11-01", location: "Sydney, Australia", location_type: "In Person", theme: "Education", prize_pool: "AUD 5,000", registration_link: "https://progcomp.org", source: "Hackathon.com", description: "University of New South Wales programming competition and hackathon for students.", country: "Australia", region: "Oceania" },

  # Global / Virtual
  { name: "Global Hack Week: AI", start_date: "2026-03-09", end_date: "2026-03-15", location: "Online", location_type: "Virtual", theme: "AI & Machine Learning", prize_pool: "$10,000 in prizes", registration_link: "https://ghw.mlh.io", source: "MLH", description: "A week-long virtual hackathon focused on AI and machine learning projects.", country: "Global", region: "Global" },
  { name: "AI Builder Jam", start_date: "2026-05-01", end_date: "2026-05-31", location: "Online", location_type: "Virtual", theme: "AI & Machine Learning", prize_pool: "$25,000", registration_link: "https://devpost.com/hackathons", source: "Devpost", description: "A month-long virtual hackathon challenging developers to build AI-powered applications.", country: "Global", region: "Global" },
  { name: "Climate Hack 2026", start_date: "2026-04-22", end_date: "2026-04-24", location: "Online + Satellite Venues", location_type: "Hybrid", theme: "Health & Sustainability", prize_pool: "$100,000", registration_link: "https://climatehack.ai", source: "Devpost", description: "Timed with Earth Day, this hackathon focuses on technology solutions for climate change.", country: "Global", region: "Global" },
  { name: "Hack for Good", start_date: "2026-07-10", end_date: "2026-07-12", location: "Online", location_type: "Virtual", theme: "Social Impact", prize_pool: "$20,000", registration_link: "https://devpost.com/hackathons", source: "Devpost", description: "Build projects that create positive social impact in communities around the world.", country: "Global", region: "Global" },
  { name: "Hackathon.com Summer Showdown", start_date: "2026-07-01", end_date: "2026-07-15", location: "Online", location_type: "Virtual", theme: "Open Innovation", prize_pool: "$30,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Two weeks to build anything. No limits, no restrictions — just pure innovation.", country: "Global", region: "Global" },
  { name: "GameJam 2026", start_date: "2026-11-07", end_date: "2026-11-09", location: "Online", location_type: "Virtual", theme: "Gaming", prize_pool: "$15,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "48 hours to build a game from scratch. Any engine, any genre, any platform.", country: "Global", region: "Global" },
  { name: "EdTech Innovation Challenge", start_date: "2026-09-05", end_date: "2026-09-07", location: "Online", location_type: "Virtual", theme: "Education", prize_pool: "$20,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Reimagine education with technology. Build tools that make learning more accessible and effective.", country: "Global", region: "Global" },
  { name: "SpaceApps Challenge 2026", start_date: "2026-10-03", end_date: "2026-10-04", location: "Worldwide", location_type: "Hybrid", theme: "Space & Science", prize_pool: "NASA Recognition", registration_link: "https://www.spaceappschallenge.org", source: "Hackathon.com", description: "NASA's annual hackathon inviting citizens to solve challenges using open data from space.", country: "Global", region: "Global" },
  { name: "DEF CON CTF Qualifier", start_date: "2026-05-17", end_date: "2026-05-19", location: "Online", location_type: "Virtual", theme: "Cybersecurity", prize_pool: "Finals Entry", registration_link: "https://defcon.org", source: "Hackathon.com", description: "The world's most prestigious capture-the-flag competition. Qualify for the finals at DEF CON in Las Vegas.", country: "Global", region: "Global" },
  { name: "Women Who Code Hackathon", start_date: "2026-03-28", end_date: "2026-03-29", location: "Online", location_type: "Virtual", theme: "Social Impact", prize_pool: "$10,000", registration_link: "https://womenwhocode.com", source: "MLH", description: "A hackathon celebrating women in tech. Build projects that empower and inspire.", country: "Global", region: "Global" },
  { name: "SwarmPod Community Hack", start_date: "2026-12-05", end_date: "2026-12-07", location: "Online", location_type: "Virtual", theme: "Web Development", prize_pool: "$5,000 + SwarmPod Pro License", registration_link: "https://folkcoder.com/hackathons", source: "FolkCoder", description: "Build something amazing with SwarmPod. Open to all skill levels. The best projects get featured on FolkCoder.", country: "Global", region: "Global" }
]

hackathons.each do |attrs|
  h = Hackathon.find_or_initialize_by(name: attrs[:name])
  h.update!(attrs.except(:name))
end

puts "Seeded #{Hackathon.count} hackathons"
