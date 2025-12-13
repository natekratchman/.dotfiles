# Control Flow Patterns

Detailed patterns for implementing control flow in Ruby-based Skills.

## IF/THEN Conditionals

### Basic Conditionals

```ruby
# Direct conditional execution
def execute(context)
  if user_wants_detailed_output?(context)
    load_cookbook("detailed_output")
    emit "Providing detailed analysis..."
  else
    load_cookbook("summary_output")
    emit "Providing summary..."
  end
end

def user_wants_detailed_output?(context)
  context.user_input.match?(/detail|comprehensive|thorough|full|complete/i)
end
```

### Chained Conditions

```ruby
def execute(context)
  if emergency_request?(context)
    load_cookbook("emergency_protocol")
  elsif high_priority?(context)
    load_cookbook("priority_handling")
  elsif standard_request?(context)
    load_cookbook("standard_workflow")
  else
    load_cookbook("evaluation_needed")
    ask_user("Could you provide more context about your request?")
  end
end
```

### Compound Conditions

```ruby
def execute(context)
  has_files = context.files.any?
  is_complex = context.user_input.length > 500
  needs_review = context.user_input.match?(/review|check|verify/i)
  
  if has_files && is_complex
    load_cookbook("complex_file_processing")
  elsif has_files && needs_review
    load_cookbook("file_review")
  elsif is_complex
    load_cookbook("complex_text_analysis")
  else
    load_cookbook("simple_processing")
  end
end
```

## CONSTANT-Driven Control Flow

### Configuration Constants

```ruby
CONSTANTS = {
  # Processing modes
  mode: "production",           # development | staging | production
  
  # Feature flags
  enable_caching: true,
  enable_validation: true,
  enable_logging: false,
  
  # Limits
  max_file_size: 10_000_000,    # 10MB
  max_iterations: 100,
  timeout_seconds: 30,
  
  # Defaults
  default_format: "markdown",
  default_language: "en",
  
  # Routing
  primary_cookbook: "standard",
  fallback_cookbook: "minimal"
}

def execute(context)
  # Mode-based behavior
  case CONSTANTS[:mode]
  when "development"
    load_cookbook("development_helpers")
    emit "[DEV MODE] Starting execution..."
  when "staging"
    load_cookbook("staging_checks")
  when "production"
    # Production has minimal overhead
  end
  
  # Feature-flag gated loading
  load_tool("tools/cache.rb") if CONSTANTS[:enable_caching]
  load_tool("tools/validator.rb") if CONSTANTS[:enable_validation]
  load_tool("tools/logger.rb") if CONSTANTS[:enable_logging]
  
  # Limit enforcement
  if context.files.any? { |f| f.size > CONSTANTS[:max_file_size] }
    emit "File exceeds maximum size of #{CONSTANTS[:max_file_size]} bytes"
    return
  end
  
  # Default application
  format = detect_format(context) || CONSTANTS[:default_format]
  load_cookbook("formats/#{format}")
end
```

### Environment-Based Constants

```ruby
ENVIRONMENTS = {
  development: {
    verbose: true,
    strict: false,
    cookbook_prefix: "dev_"
  },
  staging: {
    verbose: true,
    strict: true,
    cookbook_prefix: "staging_"
  },
  production: {
    verbose: false,
    strict: true,
    cookbook_prefix: ""
  }
}

CURRENT_ENV = :production  # Change per deployment

def config
  ENVIRONMENTS[CURRENT_ENV]
end

def execute(context)
  cookbook_name = "#{config[:cookbook_prefix]}main_workflow"
  load_cookbook(cookbook_name)
  
  if config[:verbose]
    load_cookbook("verbose_output")
  end
  
  if config[:strict]
    load_tool("tools/strict_validator.rb")
  end
end
```

## Loops and Iteration

### Processing Collections

```ruby
def execute(context)
  load_cookbook("batch_processing")
  
  results = []
  context.files.each_with_index do |file, index|
    emit "Processing file #{index + 1} of #{context.files.count}: #{file.name}"
    
    result = process_file(file)
    results << result
    
    # Early exit on critical error
    break if result[:critical_error]
  end
  
  load_cookbook("batch_summary")
  summarize_results(results)
end
```

### Iterative Refinement

```ruby
MAX_REFINEMENT_ROUNDS = 3

def execute(context)
  result = initial_generation(context)
  
  MAX_REFINEMENT_ROUNDS.times do |round|
    load_cookbook("refinement")
    
    quality = assess_quality(result)
    break if quality >= 0.9  # Good enough
    
    emit "Round #{round + 1}: Quality #{(quality * 100).round}%, refining..."
    result = refine(result, quality)
  end
  
  load_prompt("final_output")
  output_result(result)
end
```

### Retry Logic

```ruby
MAX_RETRIES = 3

def execute(context)
  attempt = 0
  
  loop do
    attempt += 1
    
    begin
      result = try_operation(context)
      output_success(result)
      break
    rescue RecoverableError => e
      if attempt < MAX_RETRIES
        emit "Attempt #{attempt} failed: #{e.message}. Retrying..."
        load_cookbook("retry_preparation")
      else
        emit "All #{MAX_RETRIES} attempts failed."
        load_cookbook("failure_handling")
        break
      end
    end
  end
end
```

## Dynamic File Reference

### Computed Cookbook Paths

```ruby
def execute(context)
  # Build path from multiple factors
  domain = detect_domain(context)      # e.g., "finance"
  action = detect_action(context)      # e.g., "analyze"
  complexity = detect_complexity(context)  # e.g., "advanced"
  
  cookbook_path = "#{domain}/#{action}_#{complexity}"
  
  if cookbook_exists?(cookbook_path)
    load_cookbook(cookbook_path)
  else
    # Fallback hierarchy
    fallbacks = [
      "#{domain}/#{action}_basic",
      "#{domain}/general",
      "general/#{action}",
      "general/fallback"
    ]
    
    loaded = fallbacks.find { |path| cookbook_exists?(path) && load_cookbook(path) }
    emit "Using fallback: #{loaded}" if loaded
  end
end

def cookbook_exists?(path)
  File.exist?("cookbook/#{path}.md")
end
```

### Template Selection

```ruby
TEMPLATES = {
  report: {
    brief:    "prompts/report_brief.md",
    standard: "prompts/report_standard.md",
    detailed: "prompts/report_detailed.md"
  },
  email: {
    formal:   "prompts/email_formal.md",
    casual:   "prompts/email_casual.md"
  },
  code: {
    minimal:  "prompts/code_minimal.md",
    documented: "prompts/code_documented.md"
  }
}

def execute(context)
  output_type = detect_output_type(context)   # :report, :email, :code
  style = detect_style(context)               # :brief, :formal, etc.
  
  template_path = TEMPLATES.dig(output_type, style)
  template_path ||= TEMPLATES.dig(output_type, :standard)
  template_path ||= "prompts/generic.md"
  
  template = read_file(template_path)
  render(template, context)
end
```

### Multi-File Loading

```ruby
def execute(context)
  # Load base instructions
  load_cookbook("base")
  
  # Conditionally layer additional instructions
  extensions = determine_extensions(context)
  
  extensions.each do |ext|
    load_cookbook("extensions/#{ext}")
  end
  
  # Load all relevant tools
  required_tools = determine_tools(context)
  required_tools.each do |tool|
    load_tool("tools/#{tool}.rb")
  end
end

def determine_extensions(context)
  extensions = []
  
  extensions << "formatting" if needs_formatting?(context)
  extensions << "validation" if needs_validation?(context)
  extensions << "optimization" if needs_optimization?(context)
  
  extensions
end
```

## Switch/Case Routing

### Simple Type Routing

```ruby
def execute(context)
  task_type = classify_task(context.user_input)
  
  case task_type
  when :generation
    load_cookbook("generation")
    generate_content(context)
  when :transformation
    load_cookbook("transformation")
    transform_content(context)
  when :analysis
    load_cookbook("analysis")
    analyze_content(context)
  when :validation
    load_cookbook("validation")
    validate_content(context)
  else
    load_cookbook("classification")
    ask_user("I couldn't determine the task type. What would you like me to do?")
  end
end
```

### Multi-Dimensional Routing

```ruby
def execute(context)
  input_type = detect_input_type(context)
  output_format = detect_output_format(context)
  
  # Two-dimensional routing table
  route = [input_type, output_format]
  
  case route
  when [:text, :summary]
    load_cookbook("text_to_summary")
  when [:text, :translation]
    load_cookbook("text_translation")
  when [:data, :chart]
    load_cookbook("data_visualization")
  when [:data, :report]
    load_cookbook("data_reporting")
  when [:code, :documentation]
    load_cookbook("code_documentation")
  when [:code, :review]
    load_cookbook("code_review")
  else
    load_cookbook("general_processing")
    emit "Processing #{input_type} to #{output_format}"
  end
end
```
