# Ruby Patterns for Skill Authoring

Reference patterns for implementing control flow in Ruby-based Skills.

## Pattern Catalog

### Conditional Branching

```ruby
# Simple if/else
def select_workflow(input)
  if input.include?("urgent")
    load_cookbook("expedited")
  else
    load_cookbook("standard")
  end
end

# Case expression with patterns
def route_by_type(file_type)
  case file_type
  when :document then load_cookbook("document_processing")
  when :image    then load_cookbook("image_handling")
  when :data     then load_cookbook("data_analysis")
  else                load_cookbook("general")
  end
end

# Guard clauses
def process(context)
  return emit("No input provided") if context.user_input.empty?
  return emit("File required") unless context.files.any?
  
  # Main logic after guards pass
  proceed_with_processing(context)
end
```

### Regex-Based Routing

```ruby
INTENT_PATTERNS = {
  create:  /\b(create|make|build|generate|new)\b/i,
  modify:  /\b(edit|update|change|modify|fix)\b/i,
  analyze: /\b(analyze|review|check|examine|audit)\b/i,
  delete:  /\b(delete|remove|clear|purge)\b/i
}

def detect_intent(input)
  INTENT_PATTERNS.each do |intent, pattern|
    return intent if input.match?(pattern)
  end
  :unknown
end

def execute(context)
  intent = detect_intent(context.user_input)
  
  case intent
  when :create  then load_cookbook("creation_workflow")
  when :modify  then load_cookbook("modification_workflow")
  when :analyze then load_cookbook("analysis_workflow")
  when :delete  then load_cookbook("deletion_workflow")
  else               ask_user("Could you clarify what you'd like to do?")
  end
end
```

### State Machine

```ruby
STATES = [:init, :gathering, :processing, :reviewing, :complete]

class SkillStateMachine
  attr_reader :state, :data
  
  def initialize
    @state = :init
    @data = {}
  end
  
  def transition(new_state)
    valid_transitions = {
      init:       [:gathering],
      gathering:  [:processing, :init],
      processing: [:reviewing, :gathering],
      reviewing:  [:complete, :processing],
      complete:   [:init]
    }
    
    if valid_transitions[@state].include?(new_state)
      @state = new_state
      true
    else
      emit "Invalid transition from #{@state} to #{new_state}"
      false
    end
  end
  
  def run_current_state(context)
    case @state
    when :init
      load_cookbook("initialization")
      transition(:gathering)
    when :gathering
      load_cookbook("gather_requirements")
      @data[:requirements] = gather(context)
      transition(:processing)
    when :processing
      load_cookbook("process_data")
      @data[:result] = process(@data[:requirements])
      transition(:reviewing)
    when :reviewing
      load_cookbook("review_output")
      if approved?
        transition(:complete)
      else
        transition(:processing)
      end
    when :complete
      load_prompt("final_output")
      render_result(@data)
    end
  end
end

def execute(context)
  machine = SkillStateMachine.new
  until machine.state == :complete
    machine.run_current_state(context)
  end
end
```

### Pipeline Processing

```ruby
PIPELINE = [
  :validate_input,
  :parse_content,
  :transform_data,
  :validate_output,
  :format_result
]

def execute(context)
  result = context.user_input
  
  PIPELINE.each do |stage|
    load_cookbook("pipeline/#{stage}")
    result = send(stage, result)
    
    if result.nil? || result[:error]
      emit "Pipeline failed at #{stage}: #{result[:error]}"
      return
    end
  end
  
  emit_result(result)
end

def validate_input(input)
  # Validation logic
end

def parse_content(validated)
  # Parsing logic
end

# ... etc
```

### Feature Toggle System

```ruby
module Features
  DEFAULTS = {
    enhanced_mode: false,
    strict_validation: true,
    experimental_output: false,
    verbose_errors: true,
    caching: true
  }
  
  @overrides = {}
  
  def self.enabled?(feature)
    @overrides.fetch(feature, DEFAULTS[feature])
  end
  
  def self.enable(feature)
    @overrides[feature] = true
  end
  
  def self.disable(feature)
    @overrides[feature] = false
  end
  
  def self.configure(overrides)
    @overrides.merge!(overrides)
  end
end

def execute(context)
  # Configure based on user preferences
  if context.user_input.match?(/strict/i)
    Features.enable(:strict_validation)
  end
  
  load_cookbook("base")
  
  if Features.enabled?(:enhanced_mode)
    load_cookbook("enhanced_extensions")
  end
  
  if Features.enabled?(:strict_validation)
    load_tool("tools/strict_validator.rb")
  end
end
```

### Error Handling

```ruby
class SkillError < StandardError; end
class ValidationError < SkillError; end
class ProcessingError < SkillError; end

def execute(context)
  begin
    validate!(context)
    result = process(context)
    output(result)
  rescue ValidationError => e
    load_cookbook("error_handling/validation")
    emit "Validation failed: #{e.message}"
    ask_user("Would you like to correct the input?")
  rescue ProcessingError => e
    load_cookbook("error_handling/processing")
    emit "Processing error: #{e.message}"
    load_cookbook("fallback_workflow")
  rescue => e
    emit "Unexpected error: #{e.message}"
    load_cookbook("error_handling/general")
  end
end

def validate!(context)
  raise ValidationError, "Input required" if context.user_input.empty?
  raise ValidationError, "Input too short" if context.user_input.length < 10
end
```

### Dynamic Method Dispatch

```ruby
HANDLERS = {
  "pdf"  => :handle_pdf,
  "docx" => :handle_docx,
  "xlsx" => :handle_spreadsheet,
  "csv"  => :handle_spreadsheet,
  "png"  => :handle_image,
  "jpg"  => :handle_image
}

def execute(context)
  context.files.each do |file|
    ext = file.extension.delete(".")
    handler = HANDLERS[ext] || :handle_generic
    
    send(handler, file)
  end
end

def handle_pdf(file)
  load_cookbook("file_handlers/pdf")
  load_tool("tools/pdf_processor.rb")
end

def handle_docx(file)
  load_cookbook("file_handlers/docx")
  load_tool("tools/docx_processor.rb")
end

def handle_spreadsheet(file)
  load_cookbook("file_handlers/spreadsheet")
  load_tool("tools/data_processor.rb")
end

def handle_image(file)
  load_cookbook("file_handlers/image")
  load_tool("tools/image_processor.rb")
end

def handle_generic(file)
  load_cookbook("file_handlers/generic")
  emit "Processing #{file.name} with generic handler"
end
```

### Composition with Modules

```ruby
module Validation
  def validate_format(content, format)
    case format
    when :json then valid_json?(content)
    when :xml  then valid_xml?(content)
    when :yaml then valid_yaml?(content)
    else true
    end
  end
end

module Transformation
  def transform(content, from:, to:)
    load_tool("tools/transformer.rb")
    execute_tool(:transform, content: content, from: from, to: to)
  end
end

module Output
  def format_output(result, style)
    load_prompt("output_styles/#{style}")
    render(read_file("prompts/output_styles/#{style}.md"), result)
  end
end

class Skill
  include Validation
  include Transformation
  include Output
  
  def execute(context)
    return unless validate_format(context.user_input, :json)
    
    result = transform(context.user_input, from: :json, to: :yaml)
    format_output(result, :detailed)
  end
end
```
