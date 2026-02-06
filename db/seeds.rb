# Founder user for local development
founder = User.find_or_create_by!(email_address: "founder@folkcoder.com") do |u|
  u.name = "Founder"
  u.password = "founder123"
end
puts "Seeded founder user: #{founder.email_address} (password: founder123)"

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
