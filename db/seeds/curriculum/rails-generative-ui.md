# Rails Generative UI: Building AI-Powered Interfaces

## Overview

Move beyond traditional chatbox interfaces. Learn to build dynamic, AI-powered user interfaces where LLMs invoke tools that render rich ViewComponents—charts, cards, forms, tables—streamed progressively to users via Turbo Streams.

**What You'll Build:** A complete generative UI system where users interact naturally and receive contextual, component-based responses instead of plain text.

---

## Module 1: Introduction to Generative UI

### Lesson 1.1: Beyond the Chatbox
- The limitations of text-only AI interfaces
- What is Generative UI?
- Real-world use cases: e-commerce, support, dashboards, content creation
- Demo: Traditional chat vs generative UI comparison

### Lesson 1.2: Architecture Overview
- The tool-based paradigm
- LLM as orchestrator, not just responder
- ViewComponents as the output medium
- Streaming for responsive UX

### Lesson 1.3: Setting Up Your Environment
- Installing Ollama locally
- Creating a new Rails 7+ application
- Adding the rails-generative-ui gem
- Configuring your first model

```ruby
# Gemfile
gem "rails-generative-ui"
gem "view_component"
gem "turbo-rails"

# config/initializers/generative_ui.rb
RailsGenerativeUi.configure do |config|
  config.ollama_url = "http://localhost:11434"
  config.model = "llama3.2"
  config.streaming = true
end
```

---

## Module 2: ViewComponents Fundamentals

### Lesson 2.1: Why ViewComponents?
- Components vs partials vs helpers
- Encapsulation and testability
- The Sidecar pattern for assets
- Performance benefits

### Lesson 2.2: Creating Your First Component
```ruby
# app/components/weather_card_component.rb
class WeatherCardComponent < ViewComponent::Base
  def initialize(city:, temperature:, conditions:, icon:)
    @city = city
    @temperature = temperature
    @conditions = conditions
    @icon = icon
  end
end
```

```erb
<%# app/components/weather_card_component.html.erb %>
<div class="weather-card">
  <h3><%= @city %></h3>
  <div class="temperature"><%= @temperature %>°</div>
  <div class="conditions">
    <span class="icon"><%= @icon %></span>
    <%= @conditions %>
  </div>
</div>
```

### Lesson 2.3: Component Variants and Slots
- Using variants for different contexts
- Slots for flexible content areas
- Polymorphic slots
- Component collections

### Lesson 2.4: Testing Components
```ruby
# spec/components/weather_card_component_spec.rb
RSpec.describe WeatherCardComponent, type: :component do
  it "renders the city name" do
    render_inline(described_class.new(
      city: "Paris",
      temperature: 22,
      conditions: "Sunny",
      icon: "☀️"
    ))

    expect(page).to have_text("Paris")
    expect(page).to have_text("22°")
  end
end
```

---

## Module 3: The Tool System

### Lesson 3.1: Understanding Tools
- Tools as capabilities for LLMs
- The tool contract: name, description, schema, execution
- How LLMs decide which tools to use
- Tool composition patterns

### Lesson 3.2: Creating a Basic Tool
```ruby
# app/tools/weather_tool.rb
class WeatherTool < RailsGenerativeUi::Tools::Tool
  name "get_weather"
  description "Get current weather conditions for any city worldwide"
  component "WeatherCardComponent"

  input_schema do
    required(:city).filled(:string)
    optional(:units).value(:string, included_in?: %w[celsius fahrenheit])
  end

  def execute(city:, units: "celsius")
    # Call weather API
    weather = WeatherService.fetch(city)

    {
      city: city,
      temperature: units == "celsius" ? weather.temp_c : weather.temp_f,
      conditions: weather.conditions,
      icon: weather.icon
    }
  end
end
```

### Lesson 3.3: Input Validation with dry-schema
- Schema definition syntax
- Required vs optional parameters
- Type coercion and constraints
- Custom validation rules
- Error messages for users

### Lesson 3.4: Tool Registration and Discovery
```ruby
# config/initializers/tools.rb
Rails.application.config.after_initialize do
  RailsGenerativeUi.register_tool(WeatherTool)
  RailsGenerativeUi.register_tool(StockPriceTool)
  RailsGenerativeUi.register_tool(SearchProductsTool)
end
```

### Lesson 3.5: Advanced Tool Patterns
- Tools that return multiple components
- Conditional component selection
- Tool chaining and dependencies
- Error handling and fallbacks

---

## Module 4: Ollama Integration

### Lesson 4.1: Ollama Fundamentals
- What is Ollama?
- Available models and capabilities
- Chat API vs Generate API
- Context windows and memory

### Lesson 4.2: The Ollama Client
```ruby
# Understanding the client internals
client = RailsGenerativeUi.ollama_client

response = client.chat(
  messages: [
    { role: "user", content: "What's the weather in Tokyo?" }
  ],
  tools: RailsGenerativeUi.tool_registry.to_ollama_format
)
```

### Lesson 4.3: Handling Tool Calls
- Parsing tool call responses
- Executing tools with validated inputs
- Formatting tool results for the LLM
- Multi-turn tool conversations

### Lesson 4.4: Error Handling and Retries
- Connection errors and timeouts
- Rate limiting strategies
- Exponential backoff with Faraday
- Graceful degradation

---

## Module 5: Streaming Responses

### Lesson 5.1: Why Streaming Matters
- Perceived performance vs actual performance
- User engagement during processing
- Progressive disclosure patterns
- Loading states and skeletons

### Lesson 5.2: Turbo Streams Basics
```erb
<%# Streaming a component update %>
<%= turbo_stream.replace "chat-response" do %>
  <%= render WeatherCardComponent.new(**@weather_data) %>
<% end %>
```

### Lesson 5.3: Server-Sent Events (SSE)
```ruby
# app/controllers/chat_controller.rb
def stream
  response.headers["Content-Type"] = "text/event-stream"
  response.headers["Cache-Control"] = "no-cache"

  RailsGenerativeUi.stream_response(params[:message]) do |chunk|
    response.stream.write("data: #{chunk.to_json}\n\n")
  end
ensure
  response.stream.close
end
```

### Lesson 5.4: Progressive Component Rendering
- Streaming text tokens
- Replacing loading indicators with components
- Handling multiple components in sequence
- Error recovery during streaming

---

## Module 6: Conversation Management

### Lesson 6.1: Conversation History
- Why history matters for context
- Session-based vs database-backed storage
- Message serialization formats
- History truncation strategies

### Lesson 6.2: The Conversation Class
```ruby
# Managing conversation state
conversation = RailsGenerativeUi::Messages::Conversation.new(session)

conversation.add_user_message("Show me the weather in Paris")
conversation.add_assistant_message(response)
conversation.add_tool_result(tool_name, result)

# Get formatted history for LLM
messages = conversation.to_messages
```

### Lesson 6.3: Message Parts
- TextPart for plain text responses
- ComponentPart for rendered UI
- Composing multi-part messages
- Serialization for persistence

### Lesson 6.4: Context Windows and Summarization
- Understanding token limits
- Sliding window strategies
- Automatic summarization
- Priority-based message retention

---

## Module 7: Controller Integration

### Lesson 7.1: The Controller Helpers Module
```ruby
class ChatController < ApplicationController
  include RailsGenerativeUi::Helpers::ControllerHelpers

  def create
    @response = generative_ui_response(
      message: params[:message],
      conversation_id: session[:conversation_id]
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chat_path }
    end
  end
end
```

### Lesson 7.2: Request Handling Patterns
- Synchronous vs asynchronous processing
- Background jobs for long operations
- Progress tracking with ActionCable
- Timeout handling

### Lesson 7.3: View Helpers
```erb
<%# app/views/chat/show.html.erb %>
<div id="chat-container">
  <%= generative_ui_messages(@conversation) %>

  <%= form_with url: chat_path, data: { turbo_stream: true } do |f| %>
    <%= f.text_field :message, placeholder: "Ask anything..." %>
    <%= f.submit "Send" %>
  <% end %>
</div>
```

### Lesson 7.4: Error Handling in Controllers
- User-friendly error messages
- Logging and debugging
- Retry mechanisms
- Fallback responses

---

## Module 8: Building Real-World Tools

### Lesson 8.1: Data Visualization Tool
```ruby
class ChartTool < RailsGenerativeUi::Tools::Tool
  name "create_chart"
  description "Create a chart visualization from data"
  component "ChartComponent"

  input_schema do
    required(:chart_type).value(:string, included_in?: %w[bar line pie])
    required(:data).array(:hash)
    optional(:title).filled(:string)
  end

  def execute(chart_type:, data:, title: nil)
    { type: chart_type, data: data, title: title }
  end
end
```

### Lesson 8.2: Search and Filter Tool
```ruby
class ProductSearchTool < RailsGenerativeUi::Tools::Tool
  name "search_products"
  description "Search products by query, category, or price range"
  component "ProductGridComponent"

  input_schema do
    optional(:query).filled(:string)
    optional(:category).filled(:string)
    optional(:min_price).filled(:decimal)
    optional(:max_price).filled(:decimal)
    optional(:limit).filled(:integer, gt?: 0, lteq?: 50)
  end

  def execute(**params)
    products = Product.search(params).limit(params[:limit] || 12)
    { products: products.map(&:to_card_data) }
  end
end
```

### Lesson 8.3: Form Generation Tool
```ruby
class DynamicFormTool < RailsGenerativeUi::Tools::Tool
  name "create_form"
  description "Generate a form for user input"
  component "DynamicFormComponent"

  input_schema do
    required(:form_type).filled(:string)
    required(:fields).array(:hash)
    optional(:submit_url).filled(:string)
  end

  def execute(form_type:, fields:, submit_url: nil)
    { form_type: form_type, fields: fields, submit_url: submit_url }
  end
end
```

### Lesson 8.4: Multi-Step Workflow Tools
- Tools that trigger other tools
- Wizard-style interfaces
- State management across steps
- Confirmation and rollback patterns

---

## Module 9: Testing Generative UI

### Lesson 9.1: Unit Testing Tools
```ruby
RSpec.describe WeatherTool do
  describe "#execute" do
    it "returns weather data for a valid city" do
      stub_weather_api("Paris", temp: 22, conditions: "Sunny")

      result = described_class.new.execute(city: "Paris")

      expect(result[:temperature]).to eq(22)
      expect(result[:conditions]).to eq("Sunny")
    end
  end

  describe "input_schema" do
    it "requires a city" do
      result = described_class.validate({})
      expect(result.errors[:city]).to include("is missing")
    end
  end
end
```

### Lesson 9.2: Mocking Ollama Responses
```ruby
RSpec.describe "Chat interaction", type: :request do
  before do
    stub_ollama_response(
      tool_calls: [
        { name: "get_weather", arguments: { city: "Paris" } }
      ]
    )
  end

  it "renders a weather component" do
    post chat_path, params: { message: "Weather in Paris?" }

    expect(response.body).to include("weather-card")
    expect(response.body).to include("Paris")
  end
end
```

### Lesson 9.3: Integration Testing with Cucumber
```gherkin
Feature: Weather queries
  Scenario: User asks about weather
    Given I am on the chat page
    When I send the message "What's the weather in Tokyo?"
    Then I should see a weather card
    And the weather card should show "Tokyo"
```

### Lesson 9.4: Testing Streaming Responses
- Capturing streamed chunks
- Testing progressive updates
- Timeout and error scenarios
- Performance benchmarking

---

## Module 10: Production Deployment

### Lesson 10.1: Configuration Management
```ruby
# config/environments/production.rb
config.generative_ui.ollama_url = ENV["OLLAMA_URL"]
config.generative_ui.model = ENV.fetch("LLM_MODEL", "llama3.2")
config.generative_ui.timeout = 30.seconds
config.generative_ui.max_retries = 3
```

### Lesson 10.2: Ollama Deployment Options
- Self-hosted Ollama
- Cloud GPU instances
- Ollama-compatible APIs (OpenAI, Anthropic)
- Load balancing multiple instances

### Lesson 10.3: Performance Optimization
- Component caching strategies
- Connection pooling
- Background processing with Sidekiq
- Database query optimization

### Lesson 10.4: Monitoring and Observability
- Request logging and tracing
- Error tracking with Sentry
- Performance metrics
- User interaction analytics

---

## Module 11: Advanced Patterns

### Lesson 11.1: Multi-Modal Tools
- Image analysis tools
- File upload handling
- Audio/video processing
- Mixed media responses

### Lesson 11.2: Authorization and Permissions
```ruby
class AdminReportTool < RailsGenerativeUi::Tools::Tool
  name "generate_report"

  def authorized?(user)
    user.admin?
  end

  def execute(**params)
    raise UnauthorizedError unless authorized?(Current.user)
    # Generate report...
  end
end
```

### Lesson 11.3: Tool Versioning and Deprecation
- Semantic versioning for tools
- Backward compatibility strategies
- Deprecation warnings
- Migration guides

### Lesson 11.4: Building a Tool Marketplace
- Packaging tools as gems
- Documentation standards
- Sharing and discovery
- Community contributions

---

## Module 12: Capstone Project

### Project: AI-Powered Dashboard

Build a complete generative UI dashboard with:

1. **Multiple Tool Types**
   - Data visualization (charts, graphs)
   - Search and filtering
   - Form generation
   - Notifications

2. **Rich Components**
   - Card grids
   - Data tables
   - Interactive charts
   - Modal dialogs

3. **Conversation Features**
   - Persistent history
   - Context awareness
   - Multi-turn interactions

4. **Production Ready**
   - Comprehensive tests
   - Error handling
   - Performance optimization
   - Deployment configuration

---

## Prerequisites

- Ruby on Rails intermediate experience
- Basic understanding of APIs
- Familiarity with HTML/CSS
- JavaScript basics (for Turbo)

## Learning Outcomes

By completing this curriculum, you will be able to:

- Design and build AI-powered generative interfaces
- Create reusable, testable ViewComponents
- Implement tools that connect LLMs to your application
- Build streaming, responsive user experiences
- Integrate Ollama or compatible LLM services
- Test AI-powered features comprehensively
- Deploy and scale generative UI applications
- Apply best practices for production systems
