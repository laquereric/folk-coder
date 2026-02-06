# Data-Driven Rails: Modern Data Engineering Patterns

## Overview

The state of the art in data engineering has shifted dramatically since the 2016 publication of the Medallion Architecture. What was once exclusive to big data platforms like Databricks is now accessible in Rails through purpose-built gems. Learn to build robust data pipelines with multi-store synchronization and Bronze/Silver/Gold data curation.

**What You'll Build:** A complete data engineering workflow in Rails—ingesting raw data, curating it through quality tiers, and synchronizing across multiple data stores.

---

## Module 1: The Evolution of Data Engineering

### Lesson 1.1: From ETL to Modern Data Lakehouse
- Traditional ETL limitations
- The data lakehouse paradigm shift
- Why Rails can now compete with Spark
- The democratization of data engineering

### Lesson 1.2: Medallion Architecture Origins
- Databricks and the 2016 publication
- Bronze, Silver, Gold tier concepts
- Data quality as a first-class concern
- Lineage and reproducibility

### Lesson 1.3: Multi-Store Reality
- No single database fits all needs
- Search (Elasticsearch), vectors (Neighbor), graphs (Neo4j)
- Synchronization challenges
- The case for unified abstraction

---

## Module 2: Rails Multistore Fundamentals

### Lesson 2.1: The Multi-Store Problem
```ruby
# Without rails-multistore: manual synchronization nightmare
class Article < ApplicationRecord
  after_commit :sync_to_elasticsearch
  after_commit :sync_to_vector_store
  after_commit :sync_to_cache

  private

  def sync_to_elasticsearch
    ElasticsearchClient.index(self)
  rescue => e
    # Error handling duplicated everywhere
  end

  # ... more duplicated sync methods
end
```

### Lesson 2.2: Unified Store Interface
```ruby
# With rails-multistore: clean, declarative
class Article < ApplicationRecord
  include RailsMultistore::Model

  multistore do
    store :search, type: :elasticsearch, url: ENV['ES_URL']
    store :vectors, type: :neighbor, model: 'text-embedding-3-small'
    store :cache, type: :redis, url: ENV['REDIS_URL']
  end

  after_commit :multistore_push, on: [:create, :update]
end
```

### Lesson 2.3: Installation and Configuration
```ruby
# Gemfile
gem 'rails-multistore'
gem 'rails-multistore-elasticsearch'
gem 'rails-multistore-neighbor'

# config/initializers/rails_multistore.rb
RailsMultistore.configure do |config|
  config.async = true
  config.queue_name = :multistore
  config.error_handler = ->(error, store, op) do
    Sentry.capture_exception(error, extra: { store: store, operation: op })
  end
end
```

### Lesson 2.4: Pushing and Querying
```ruby
# Automatic push on save
article = Article.create!(title: "AI in 2026", content: "...")
# => Automatically pushed to all configured stores

# Query across all stores
results = Article.multistore_query("artificial intelligence")
# => Aggregated results from Elasticsearch, vector search, etc.

# Query specific store
Article.multistore_query("AI", stores: [:search])
```

---

## Module 3: Creating Store Adapters

### Lesson 3.1: Adapter Interface
```ruby
# lib/rails_multistore_custom/adapter.rb
module RailsMultistoreCustom
  class Adapter
    def initialize(options)
      @client = CustomClient.new(options[:url])
    end

    def push(record)
      @client.upsert(
        id: record.id,
        data: record.to_multistore_hash
      )
    end

    def query(query_string, options = {})
      @client.search(query_string, options).map do |hit|
        { id: hit['id'], score: hit['score'], data: hit['data'] }
      end
    end

    def delete(record)
      @client.delete(record.id)
    end
  end
end
```

### Lesson 3.2: Registering Custom Adapters
```ruby
# config/initializers/multistore_adapters.rb
RailsMultistore.register_adapter(:custom, RailsMultistoreCustom::Adapter)

# Now usable in models
class Document < ApplicationRecord
  include RailsMultistore::Model

  multistore do
    store :custom_store, type: :custom, url: 'http://custom:8080'
  end
end
```

### Lesson 3.3: Store-Specific Serialization
```ruby
class Article < ApplicationRecord
  include RailsMultistore::Model

  multistore do
    store :search, type: :elasticsearch do |record|
      {
        title: record.title,
        content: record.content,
        published_at: record.published_at
      }
    end

    store :vectors, type: :neighbor do |record|
      {
        embedding_text: "#{record.title} #{record.content}",
        metadata: { id: record.id, type: 'article' }
      }
    end
  end
end
```

---

## Module 4: Medallion Architecture in Rails

### Lesson 4.1: The Three Tiers
```
┌─────────────────────────────────────────────────────────┐
│                         GOLD                             │
│  Business-ready aggregates, metrics, features           │
│  "What decisions can we make?"                          │
├─────────────────────────────────────────────────────────┤
│                        SILVER                            │
│  Cleansed, validated, deduplicated                      │
│  "What is the truth?"                                   │
├─────────────────────────────────────────────────────────┤
│                        BRONZE                            │
│  Raw ingestion, append-only, immutable                  │
│  "What did we receive?"                                 │
└─────────────────────────────────────────────────────────┘
```

### Lesson 4.2: Installing Medallion
```ruby
# Gemfile
gem 'medallion'

# Generate tiered models
rails generate medallion:model User bronze name:string email:string raw_payload:jsonb
rails generate medallion:model User silver name:string email:string validated_at:datetime
rails generate medallion:model User gold full_name:string email:string tier:string
```

### Lesson 4.3: Bronze Layer - Raw Ingestion
```ruby
# app/models/bronze/user.rb
module Bronze
  class User < ApplicationRecord
    include Medallion::Bronze

    # Store exactly what we received
    validates :raw_payload, presence: true

    # Never modify bronze records
    before_update { raise Medallion::ImmutableError }
  end
end

# Ingestion
Bronze::User.create!(
  name: "john doe",
  email: "JOHN@EXAMPLE.COM",
  raw_payload: api_response.to_json
)
```

### Lesson 4.4: Silver Layer - Curation
```ruby
# app/models/silver/user.rb
module Silver
  class User < ApplicationRecord
    include Medallion::Silver

    belongs_to :bronze_source, class_name: 'Bronze::User'

    validates :email, format: URI::MailTo::EMAIL_REGEXP
    validates :name, presence: true
  end
end

# Curation with transformation
bronze_user.curate_to_silver(Silver::User) do |source, target|
  target.name = source.name.titleize
  target.email = source.email.downcase.strip
  target.validated_at = Time.current
end
```

### Lesson 4.5: Gold Layer - Business Logic
```ruby
# app/models/gold/user.rb
module Gold
  class User < ApplicationRecord
    include Medallion::Gold

    belongs_to :silver_source, class_name: 'Silver::User'

    def self.premium_users
      where(tier: 'premium')
    end
  end
end

# Aggregate with business rules
silver_user.curate_to_gold(Gold::User) do |source, target|
  target.full_name = source.name
  target.email = source.email
  target.tier = calculate_tier(source)
end
```

---

## Module 5: Data Lineage

### Lesson 5.1: Why Lineage Matters
- Debugging data issues
- Regulatory compliance (GDPR, CCPA)
- Reproducibility
- Impact analysis

### Lesson 5.2: Envelope-Based Lineage
```ruby
# Medallion automatically tracks lineage
gold_user = Gold::User.find(123)

gold_user.lineage
# => {
#   bronze: #<Bronze::User id: 456, created_at: "2026-01-15">,
#   silver: #<Silver::User id: 789, curated_at: "2026-01-15">,
#   gold: #<Gold::User id: 123, curated_at: "2026-01-15">
# }

# Trace back to source
gold_user.bronze_source
# => #<Bronze::User> with original raw_payload
```

### Lesson 5.3: Lineage Queries
```ruby
# Find all gold records from a specific bronze source
Gold::User.where(bronze_source_id: bronze_id)

# Audit trail
class LineageAudit
  def self.trace(gold_record)
    {
      ingested_at: gold_record.bronze_source.created_at,
      cleansed_at: gold_record.silver_source.curated_at,
      published_at: gold_record.curated_at,
      transformations: gold_record.transformation_log
    }
  end
end
```

---

## Module 6: Combining Multistore with Medallion

### Lesson 6.1: The Complete Pipeline
```ruby
class Article < ApplicationRecord
  include RailsMultistore::Model
  include Medallion::Gold

  belongs_to :silver_source, class_name: 'Silver::Article'

  multistore do
    store :search, type: :elasticsearch
    store :vectors, type: :neighbor
  end

  # Only gold-tier data goes to external stores
  after_commit :multistore_push, on: [:create, :update]
end
```

### Lesson 6.2: Bronze Ingestion with Validation
```ruby
class DataIngestionService
  def ingest(raw_data)
    # 1. Bronze: Store raw
    bronze = Bronze::Article.create!(raw_payload: raw_data)

    # 2. Silver: Cleanse
    silver = bronze.curate_to_silver(Silver::Article) do |src, tgt|
      tgt.title = sanitize(src.raw_payload['title'])
      tgt.content = sanitize(src.raw_payload['content'])
    end

    # 3. Gold: Enrich and publish
    gold = silver.curate_to_gold(Gold::Article) do |src, tgt|
      tgt.title = src.title
      tgt.content = src.content
      tgt.reading_time = calculate_reading_time(src.content)
      tgt.category = classify(src.content)
    end

    # 4. Multistore: Sync to search/vectors automatically via callback
    gold
  end
end
```

### Lesson 6.3: Reprocessing Pipeline
```ruby
class ReprocessingJob < ApplicationJob
  def perform(bronze_id)
    bronze = Bronze::Article.find(bronze_id)

    # Re-curate with updated logic
    silver = bronze.recurate_to_silver(Silver::Article) do |src, tgt|
      # New cleansing logic
    end

    gold = silver.recurate_to_gold(Gold::Article) do |src, tgt|
      # New enrichment logic
    end

    # Multistore automatically syncs updated gold record
  end
end
```

---

## Module 7: Testing Data Pipelines

### Lesson 7.1: Testing Medallion Curation
```ruby
RSpec.describe "Article curation" do
  let(:bronze) { Bronze::Article.create!(raw_payload: raw_data) }

  it "cleanses data in silver tier" do
    silver = bronze.curate_to_silver(Silver::Article) do |src, tgt|
      tgt.title = src.raw_payload['title'].strip
    end

    expect(silver.title).to eq("Clean Title")
    expect(silver.bronze_source).to eq(bronze)
  end

  it "maintains lineage through gold" do
    silver = bronze.curate_to_silver(Silver::Article) { |s,t| t.title = s.raw_payload['title'] }
    gold = silver.curate_to_gold(Gold::Article) { |s,t| t.title = s.title }

    expect(gold.lineage[:bronze]).to eq(bronze)
  end
end
```

### Lesson 7.2: Testing Multistore
```ruby
RSpec.describe Article do
  before do
    stub_elasticsearch
    stub_vector_store
  end

  it "pushes to all stores on create" do
    article = Article.create!(title: "Test", content: "Content")

    expect(elasticsearch_client).to have_received(:index).with(
      hash_including(id: article.id)
    )
    expect(vector_store).to have_received(:upsert)
  end

  it "queries across stores" do
    stub_search_results([{ id: 1, score: 0.9 }])

    results = Article.multistore_query("test")
    expect(results.first[:id]).to eq(1)
  end
end
```

---

## Module 8: Production Patterns

### Lesson 8.1: Error Handling and Retry
```ruby
RailsMultistore.configure do |config|
  config.error_handler = ->(error, store, operation) do
    case error
    when Timeout::Error
      RetryStoreJob.perform_later(store, operation)
    when ValidationError
      # Log but don't retry
      Rails.logger.error("Validation failed for #{store}: #{error}")
    else
      Sentry.capture_exception(error)
      raise error
    end
  end
end
```

### Lesson 8.2: Monitoring Pipeline Health
```ruby
class PipelineHealthCheck
  def self.run
    {
      bronze_backlog: Bronze::Article.where(curated: false).count,
      silver_backlog: Silver::Article.where(curated: false).count,
      store_lag: check_store_lag,
      last_successful_run: last_run_timestamp
    }
  end

  def self.check_store_lag
    gold_count = Gold::Article.count
    es_count = Elasticsearch::Client.count(index: 'articles')

    { elasticsearch: gold_count - es_count }
  end
end
```

### Lesson 8.3: Backfilling and Migration
```ruby
class BackfillPipelineJob < ApplicationJob
  def perform(batch_size: 1000)
    Bronze::Article.where(curated: false).find_in_batches(batch_size: batch_size) do |batch|
      batch.each do |bronze|
        DataIngestionService.new.process(bronze)
      end
    end
  end
end
```

---

## Module 9: Capstone Project

### Project: E-Commerce Data Pipeline

Build a complete data pipeline for an e-commerce platform:

1. **Bronze Layer**
   - Ingest orders from webhook
   - Store raw API responses
   - Handle duplicates via idempotency

2. **Silver Layer**
   - Cleanse customer data
   - Validate addresses
   - Normalize currencies

3. **Gold Layer**
   - Calculate order totals
   - Determine customer lifetime value
   - Generate product recommendations

4. **Multi-Store Sync**
   - Elasticsearch for order search
   - Vector store for recommendations
   - Analytics database for reporting

5. **Production Ready**
   - Error handling and retry
   - Pipeline monitoring
   - Backfill support

---

## Prerequisites

- Ruby on Rails intermediate experience
- Basic understanding of databases
- Familiarity with background jobs (Sidekiq/ActiveJob)

## Learning Outcomes

By completing this curriculum, you will be able to:

- Implement Medallion Architecture in Rails applications
- Synchronize data across multiple stores with rails-multistore
- Build robust data ingestion and curation pipelines
- Maintain data lineage for compliance and debugging
- Test data pipelines comprehensively
- Monitor and operate production data systems
- Apply modern data engineering patterns in traditional Rails apps
