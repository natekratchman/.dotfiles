# Ruby Skill DSL API Reference

Complete reference for all DSL methods available in skill.rb files.

## Context Object

The `context` object is passed to `execute(context)` and contains:

| Property | Type | Description |
|----------|------|-------------|
| `user_input` | `String` | The user's request text |
| `files` | `Array<File>` | Uploaded files |
| `conversation` | `Array<Message>` | Conversation history |
| `metadata` | `Hash` | Additional context metadata |

### File Object Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Original filename |
| `path` | `String` | Path to file |
| `size` | `Integer` | File size in bytes |
| `extension` | `String` | File extension (e.g., ".pdf") |
| `content` | `String` | File contents (if text) |

## Core DSL Methods

### File Loading

#### `read_file(path) → String`

Read any file from the skill directory.

```ruby
content = read_file("cookbook/main.md")
config = read_file("config/settings.yaml")
```

#### `load_cookbook(name) → String`

Load a cookbook file. Automatically prefixes `cookbook/` and suffixes `.md`.

```ruby
load_cookbook("creation")        # Loads cookbook/creation.md
load_cookbook("workflows/fast")  # Loads cookbook/workflows/fast.md
```

#### `load_prompt(name) → String`

Load a prompt template. Automatically prefixes `prompts/` and suffixes `.md`.

```ruby
load_prompt("output")            # Loads prompts/output.md
load_prompt("errors/validation") # Loads prompts/errors/validation.md
```

#### `load_tool(path) → void`

Load a Ruby tool script. Claude reads and understands the tool's capabilities.

```ruby
load_tool("tools/validator.rb")
load_tool("tools/processors/pdf.rb")
```

#### `load_reference(name) → String`

Load reference documentation. Automatically prefixes `references/` and suffixes `.md`.

```ruby
load_reference("api_docs")
load_reference("schemas/database")
```

### Output Methods

#### `emit(message) → void`

Output an instruction or message. Emitted content becomes part of Claude's working instructions.

```ruby
emit "Processing file..."
emit "Use the validation rules defined above."
emit "WARNING: Large file detected, processing may be slow."
```

#### `ask_user(question) → void`

Request clarification from the user. Pauses execution until user responds.

```ruby
ask_user("Which output format would you prefer: PDF or DOCX?")
ask_user("Should I include the detailed analysis?")
```

### Template Methods

#### `render(template, vars) → String`

Interpolate variables into a template string. Uses `{{variable}}` syntax.

```ruby
template = "Hello {{name}}, your {{item}} is ready."
result = render(template, { name: "User", item: "report" })
# => "Hello User, your report is ready."
```

Supports nested access:

```ruby
template = "Status: {{result.status}}"
render(template, { result: { status: "complete" } })
```

### Validation Methods

#### `validate(data, schema) → Hash`

Validate data against a schema. Returns `{ valid: Boolean, errors: Array }`.

Schema options:
- `required: true` - Field must be present
- `type: Class` - Field must be instance of class
- `pattern: Regex` - String must match pattern
- `min: Number` - Minimum value/length
- `max: Number` - Maximum value/length

```ruby
schema = {
  name: { required: true, type: String },
  age: { type: Integer, min: 0, max: 150 },
  email: { pattern: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
}

result = validate({ name: "Test", age: 25 }, schema)
# => { valid: true, errors: [] }
```

### Tool Execution

#### `execute_tool(tool_name, **args) → Hash`

Execute a loaded tool with arguments. Returns tool-specific result.

```ruby
load_tool("tools/pdf_processor.rb")
result = execute_tool(:extract_text, file: context.files.first)
# => { text: "...", pages: 5 }
```

### File System Methods

#### `file_exists?(path) → Boolean`

Check if a file exists in the skill directory.

```ruby
if file_exists?("cookbook/advanced.md")
  load_cookbook("advanced")
else
  load_cookbook("basic")
end
```

#### `list_files(directory) → Array<String>`

List files in a directory.

```ruby
cookbooks = list_files("cookbook")
# => ["creation.md", "editing.md", "analysis.md"]

tools = list_files("tools")
# => ["validator.rb", "formatter.rb"]
```

## Control Flow Constructs

### CONSTANTS Hash

Define configuration constants that influence behavior:

```ruby
CONSTANTS = {
  # Feature flags
  enable_validation: true,
  enable_caching: false,
  
  # Processing limits
  max_file_size: 10_000_000,
  max_retries: 3,
  
  # Defaults
  default_format: "markdown",
  default_mode: "standard",
  
  # Routing
  routes: {
    create: "creation",
    edit: "editing"
  }
}
```

Access in code:

```ruby
def execute(context)
  if CONSTANTS[:enable_validation]
    load_tool("tools/validator.rb")
  end
  
  format = detect_format(context) || CONSTANTS[:default_format]
end
```

### Pattern Matching

Define patterns for intent detection:

```ruby
PATTERNS = {
  create: /\b(create|make|generate|new)\b/i,
  edit: /\b(edit|modify|update|change)\b/i,
  analyze: /\b(analyze|review|check|examine)\b/i
}

def detect_intent(input)
  PATTERNS.find { |_, pattern| input.match?(pattern) }&.first
end
```

### State Machine

For multi-step workflows:

```ruby
STATES = [:init, :gather, :process, :output]
TRANSITIONS = {
  init: [:gather],
  gather: [:process, :init],
  process: [:output, :gather],
  output: [:init]
}

def valid_transition?(from, to)
  TRANSITIONS[from]&.include?(to)
end
```

## Method Signatures

### Required Methods

#### `execute(context) → void`

Main entry point. Must be defined in every skill.rb.

```ruby
def execute(context)
  # Skill logic here
end
```

### Optional Methods

Define helper methods as needed:

```ruby
def detect_operation(input)
  # Operation detection logic
end

def process_files(files)
  # File processing logic
end

def generate_output(result)
  # Output generation logic
end
```

## Error Handling

### Raising Errors

```ruby
def validate_input(context)
  raise ArgumentError, "Input required" if context.user_input.empty?
  raise TypeError, "Invalid file type" unless valid_file_type?(context.files.first)
end
```

### Handling Errors

```ruby
def execute(context)
  begin
    validate_input(context)
    process(context)
  rescue ArgumentError => e
    emit "Input Error: #{e.message}"
    load_cookbook("error_recovery/input")
  rescue => e
    emit "Unexpected Error: #{e.message}"
    load_cookbook("error_recovery/general")
  end
end
```

## Best Practices

### Method Organization

```ruby
# skill.rb

# 1. Constants at top
CONSTANTS = { ... }
PATTERNS = { ... }

# 2. Entry point
def execute(context)
  ...
end

# 3. Detection methods
def detect_intent(input)
  ...
end

# 4. Processing methods
def process_request(context)
  ...
end

# 5. Output methods
def generate_output(result)
  ...
end

# 6. Utility methods
def helper_method(arg)
  ...
end
```

### Documentation

```ruby
# Detect the primary intent from user input
# @param input [String] User's request text
# @return [Symbol] Detected intent (:create, :edit, :analyze, or :unknown)
def detect_intent(input)
  ...
end
```
