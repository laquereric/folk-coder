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
      - A database container (SQLite in dev, Postgres-ready for production)
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

puts "Seeded #{Lesson.count} lessons in #{CurriculumModule.count} module(s)"

# Hackathons
hackathons = [
  { name: "HackMIT 2026", start_date: "2026-09-19", end_date: "2026-09-20", location: "MIT, Cambridge, MA", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "$50,000", registration_link: "https://hackmit.org", source: "MLH", description: "MIT's premier hackathon bringing together 1,000+ hackers to build innovative projects in 24 hours." },
  { name: "PennApps XXIV", start_date: "2026-09-12", end_date: "2026-09-14", location: "UPenn, Philadelphia, PA", location_type: "In Person", theme: "Open Innovation", prize_pool: "$30,000", registration_link: "https://pennapps.com", source: "MLH", description: "One of the oldest college hackathons in the nation. Build anything you can dream up." },
  { name: "TreeHacks 2026", start_date: "2026-02-14", end_date: "2026-02-16", location: "Stanford University, CA", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "$40,000", registration_link: "https://treehacks.com", source: "MLH", description: "Stanford's annual hackathon focused on projects that make a positive impact on the world." },
  { name: "CalHacks 11.0", start_date: "2026-10-17", end_date: "2026-10-19", location: "UC Berkeley, CA", location_type: "In Person", theme: "AI & Machine Learning", prize_pool: "$75,000", registration_link: "https://calhacks.io", source: "MLH", description: "The world's largest collegiate hackathon, hosted at UC Berkeley." },
  { name: "HackNY 2026", start_date: "2026-04-11", end_date: "2026-04-12", location: "New York, NY", location_type: "In Person", theme: "Civic Tech", prize_pool: "$15,000", registration_link: "https://hackny.org", source: "MLH", description: "Build technology that serves the people of New York City." },
  { name: "Global Hack Week: AI", start_date: "2026-03-09", end_date: "2026-03-15", location: "Online", location_type: "Virtual", theme: "AI & Machine Learning", prize_pool: "$10,000 in prizes", registration_link: "https://ghw.mlh.io", source: "MLH", description: "A week-long virtual hackathon focused on AI and machine learning projects." },
  { name: "Hack the North 2026", start_date: "2026-09-26", end_date: "2026-09-28", location: "University of Waterloo, Canada", location_type: "In Person", theme: "Open Innovation", prize_pool: "$50,000 CAD", registration_link: "https://hackthenorth.com", source: "MLH", description: "Canada's biggest hackathon, bringing together 1,500+ hackers from around the world." },
  { name: "ETHGlobal New York", start_date: "2026-06-20", end_date: "2026-06-22", location: "New York, NY", location_type: "In Person", theme: "Web3 & Blockchain", prize_pool: "$500,000", registration_link: "https://ethglobal.com", source: "Devpost", description: "Build the future of decentralized applications at the world's leading Ethereum hackathon." },
  { name: "AI Builder Jam", start_date: "2026-05-01", end_date: "2026-05-31", location: "Online", location_type: "Virtual", theme: "AI & Machine Learning", prize_pool: "$25,000", registration_link: "https://devpost.com/hackathons", source: "Devpost", description: "A month-long virtual hackathon challenging developers to build AI-powered applications." },
  { name: "Climate Hack 2026", start_date: "2026-04-22", end_date: "2026-04-24", location: "Online + Satellite Venues", location_type: "Hybrid", theme: "Health & Sustainability", prize_pool: "$100,000", registration_link: "https://climatehack.ai", source: "Devpost", description: "Timed with Earth Day, this hackathon focuses on technology solutions for climate change." },
  { name: "Hack for Good", start_date: "2026-07-10", end_date: "2026-07-12", location: "Online", location_type: "Virtual", theme: "Social Impact", prize_pool: "$20,000", registration_link: "https://devpost.com/hackathons", source: "Devpost", description: "Build projects that create positive social impact in communities around the world." },
  { name: "FinTech Disrupt", start_date: "2026-08-15", end_date: "2026-08-17", location: "San Francisco, CA", location_type: "In Person", theme: "FinTech", prize_pool: "$60,000", registration_link: "https://devpost.com/hackathons", source: "Devpost", description: "Reimagine financial services with cutting-edge technology. Sponsored by leading banks and payment providers." },
  { name: "RubyConf Hack Day", start_date: "2026-11-15", end_date: "2026-11-15", location: "Chicago, IL", location_type: "In Person", theme: "Open Source", prize_pool: "Swag & Recognition", registration_link: "https://rubyconf.org", source: "RubyConf", description: "A single-day hack event at RubyConf, focused on contributing to Ruby open source projects." },
  { name: "Rails World Hackathon", start_date: "2026-10-08", end_date: "2026-10-09", location: "Amsterdam, Netherlands", location_type: "In Person", theme: "Web Development", prize_pool: "$10,000", registration_link: "https://rubyonrails.org/world", source: "RubyConf", description: "Build something amazing with Rails at the official Rails World conference hackathon." },
  { name: "RailsConf Open Source Sprint", start_date: "2026-05-06", end_date: "2026-05-07", location: "Detroit, MI", location_type: "In Person", theme: "Open Source", prize_pool: "Community Recognition", registration_link: "https://railsconf.org", source: "RubyConf", description: "Contribute to Rails and the Ruby ecosystem at this community-driven open source sprint." },
  { name: "Hackathon.com Summer Showdown", start_date: "2026-07-01", end_date: "2026-07-15", location: "Online", location_type: "Virtual", theme: "Open Innovation", prize_pool: "$30,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Two weeks to build anything. No limits, no restrictions — just pure innovation." },
  { name: "IoT World Hack", start_date: "2026-06-05", end_date: "2026-06-07", location: "Austin, TX", location_type: "Hybrid", theme: "IoT & Hardware", prize_pool: "$35,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Connect the physical and digital worlds. Build IoT projects that push boundaries." },
  { name: "Health Tech Sprint", start_date: "2026-08-22", end_date: "2026-08-24", location: "Boston, MA", location_type: "In Person", theme: "Health & Sustainability", prize_pool: "$45,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Innovate in healthcare technology. Build solutions that improve patient outcomes and healthcare delivery." },
  { name: "GameJam 2026", start_date: "2026-11-07", end_date: "2026-11-09", location: "Online", location_type: "Virtual", theme: "Gaming", prize_pool: "$15,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "48 hours to build a game from scratch. Any engine, any genre, any platform." },
  { name: "EdTech Innovation Challenge", start_date: "2026-09-05", end_date: "2026-09-07", location: "Online", location_type: "Virtual", theme: "Education", prize_pool: "$20,000", registration_link: "https://hackathon.com", source: "Hackathon.com", description: "Reimagine education with technology. Build tools that make learning more accessible and effective." },
  { name: "SpaceApps Challenge 2026", start_date: "2026-10-03", end_date: "2026-10-04", location: "Worldwide", location_type: "Hybrid", theme: "Space & Science", prize_pool: "NASA Recognition", registration_link: "https://www.spaceappschallenge.org", source: "Hackathon.com", description: "NASA's annual hackathon inviting citizens to solve challenges using open data from space." },
  { name: "DEF CON CTF Qualifier", start_date: "2026-05-17", end_date: "2026-05-19", location: "Online", location_type: "Virtual", theme: "Cybersecurity", prize_pool: "Finals Entry", registration_link: "https://defcon.org", source: "Hackathon.com", description: "The world's most prestigious capture-the-flag competition. Qualify for the finals at DEF CON in Las Vegas." },
  { name: "Women Who Code Hackathon", start_date: "2026-03-28", end_date: "2026-03-29", location: "Online", location_type: "Virtual", theme: "Social Impact", prize_pool: "$10,000", registration_link: "https://womenwhocode.com", source: "MLH", description: "A hackathon celebrating women in tech. Build projects that empower and inspire." },
  { name: "Junction 2026", start_date: "2026-11-14", end_date: "2026-11-16", location: "Helsinki, Finland", location_type: "In Person", theme: "Open Innovation", prize_pool: "EUR 20,000", registration_link: "https://hackjunction.com", source: "Hackathon.com", description: "Europe's leading hackathon, bringing together 1,500 developers in Helsinki." },
  { name: "SwarmPod Community Hack", start_date: "2026-12-05", end_date: "2026-12-07", location: "Online", location_type: "Virtual", theme: "Web Development", prize_pool: "$5,000 + SwarmPod Pro License", registration_link: "https://folkcoder.com/hackathons", source: "FolkCoder", description: "Build something amazing with SwarmPod. Open to all skill levels. The best projects get featured on FolkCoder." }
]

hackathons.each do |attrs|
  Hackathon.find_or_create_by!(name: attrs[:name]) do |h|
    h.start_date = attrs[:start_date]
    h.end_date = attrs[:end_date]
    h.location = attrs[:location]
    h.location_type = attrs[:location_type]
    h.theme = attrs[:theme]
    h.prize_pool = attrs[:prize_pool]
    h.registration_link = attrs[:registration_link]
    h.source = attrs[:source]
    h.description = attrs[:description]
  end
end

puts "Seeded #{Hackathon.count} hackathons"
