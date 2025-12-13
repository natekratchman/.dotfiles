# Complete Example: Document Processor Skill

A fully implemented Ruby-based Skill demonstrating all major patterns.

## Skill Structure

```
.claude/skills/document-processor/
├── SKILL.md
├── skill.rb
├── cookbook/
│   ├── creation.md
│   ├── editing.md
│   ├── analysis.md
│   ├── conversion.md
│   └── batch_processing.md
├── prompts/
│   ├── output_report.md
│   ├── output_summary.md
│   └── error_message.md
├── tools/
│   ├── pdf_handler.rb
│   ├── docx_handler.rb
│   ├── validator.rb
│   └── formatter.rb
└── references/
    └── supported_formats.md
```

## SKILL.md

```markdown
---
name: document-processor
description: Process, analyze, and transform documents. Use when users want to create, edit, analyze, or convert documents including PDF, DOCX, TXT, and Markdown files. Supports batch processing, format conversion, content extraction, and document analysis.
---

# Document Processor

Ruby-controlled document processing skill.

## Execution

Read and interpret `skill.rb` to determine the processing workflow based on user input and provided files.

## Quick Reference

- **Creation**: Generate new documents from specifications
- **Editing**: Modify existing document content
- **Analysis**: Extract insights, summarize, review
- **Conversion**: Transform between formats
- **Batch**: Process multiple documents

Load the appropriate cookbook based on the detected operation type.
```

## skill.rb

```ruby
# Document Processor Skill
# Ruby control flow for document operations

#===============================================================================
# CONSTANTS - Configure skill behavior
#===============================================================================

CONSTANTS = {
  # Supported formats
  supported_input: %w[pdf docx doc txt md html rtf],
  supported_output: %w[pdf docx txt md html],
  
  # Processing limits
  max_file_size_mb: 50,
  max_batch_size: 20,
  max_pages: 500,
  
  # Quality settings
  default_quality: "standard",  # draft | standard | high
  enable_ocr: true,
  preserve_formatting: true,
  
  # Output preferences
  default_output_format: "docx",
  include_metadata: true,
  generate_summary: true
}

OPERATION_PATTERNS = {
  create: /\b(create|make|generate|write|draft|compose)\b/i,
  edit:   /\b(edit|modify|update|change|fix|correct|revise)\b/i,
  analyze:/\b(analyze|review|summarize|extract|examine|audit)\b/i,
  convert:/\b(convert|transform|export|change.+to|save.+as)\b/i,
  batch:  /\b(batch|multiple|all|each|every|bulk)\b/i
}

FORMAT_PATTERNS = {
  pdf:  /\bpdf\b/i,
  docx: /\b(docx?|word)\b/i,
  txt:  /\b(txt|text|plain)\b/i,
  md:   /\b(md|markdown)\b/i,
  html: /\bhtml?\b/i
}

#===============================================================================
# MAIN ENTRY POINT
#===============================================================================

def execute(context)
  # Step 1: Validate inputs
  validation = validate_request(context)
  unless validation[:valid]
    load_prompt("error_message")
    emit validation[:error]
    return
  end
  
  # Step 2: Detect operation type
  operation = detect_operation(context.user_input)
  
  # Step 3: Load operation-specific cookbook
  load_cookbook(operation.to_s)
  
  # Step 4: Handle files if present
  if context.files.any?
    process_files(context.files, operation)
  end
  
  # Step 5: Execute operation
  result = execute_operation(context, operation)
  
  # Step 6: Generate output
  generate_output(result, context)
end

#===============================================================================
# VALIDATION
#===============================================================================

def validate_request(context)
  # Check for empty request
  if context.user_input.strip.empty? && context.files.empty?
    return { valid: false, error: "Please provide a document or describe what you'd like to create." }
  end
  
  # Validate file formats
  context.files.each do |file|
    ext = file.extension.delete(".").downcase
    unless CONSTANTS[:supported_input].include?(ext)
      return { 
        valid: false, 
        error: "Unsupported format: .#{ext}. Supported: #{CONSTANTS[:supported_input].join(', ')}" 
      }
    end
  end
  
  # Check file sizes
  oversized = context.files.find { |f| f.size > CONSTANTS[:max_file_size_mb] * 1_000_000 }
  if oversized
    return { valid: false, error: "File '#{oversized.name}' exceeds #{CONSTANTS[:max_file_size_mb]}MB limit." }
  end
  
  # Check batch size
  if context.files.count > CONSTANTS[:max_batch_size]
    return { valid: false, error: "Maximum #{CONSTANTS[:max_batch_size]} files per batch." }
  end
  
  { valid: true }
end

#===============================================================================
# OPERATION DETECTION
#===============================================================================

def detect_operation(input)
  # Check for explicit operation keywords
  OPERATION_PATTERNS.each do |operation, pattern|
    return operation if input.match?(pattern)
  end
  
  # Default based on context
  :analyze  # Safe default - non-destructive
end

def detect_target_format(input)
  FORMAT_PATTERNS.each do |format, pattern|
    return format if input.match?(pattern)
  end
  CONSTANTS[:default_output_format].to_sym
end

def detect_quality(input)
  case input
  when /\b(draft|quick|fast)\b/i
    "draft"
  when /\b(high|best|premium|quality)\b/i
    "high"
  else
    CONSTANTS[:default_quality]
  end
end

#===============================================================================
# FILE PROCESSING
#===============================================================================

def process_files(files, operation)
  files.each do |file|
    ext = file.extension.delete(".").downcase
    
    # Load appropriate handler
    case ext
    when "pdf"
      load_tool("tools/pdf_handler.rb")
      if CONSTANTS[:enable_ocr] && needs_ocr?(file)
        emit "Enabling OCR for scanned PDF..."
      end
    when "docx", "doc"
      load_tool("tools/docx_handler.rb")
      if CONSTANTS[:preserve_formatting]
        emit "Preserving document formatting..."
      end
    when "txt", "md"
      # Plain text needs minimal tooling
    when "html"
      load_tool("tools/html_handler.rb")
    end
  end
  
  # Load validator for all operations
  load_tool("tools/validator.rb")
end

def needs_ocr?(pdf_file)
  # Heuristic: check if PDF has extractable text
  # In practice, tool would determine this
  true
end

#===============================================================================
# OPERATION EXECUTION
#===============================================================================

def execute_operation(context, operation)
  case operation
  when :create
    execute_creation(context)
  when :edit
    execute_editing(context)
  when :analyze
    execute_analysis(context)
  when :convert
    execute_conversion(context)
  when :batch
    execute_batch(context)
  end
end

def execute_creation(context)
  quality = detect_quality(context.user_input)
  format = detect_target_format(context.user_input)
  
  emit "Creating #{quality} quality #{format.upcase} document..."
  
  load_tool("tools/formatter.rb") if quality == "high"
  
  {
    operation: :create,
    format: format,
    quality: quality,
    content: context.user_input
  }
end

def execute_editing(context)
  return { error: "No document provided for editing" } if context.files.empty?
  
  emit "Editing #{context.files.count} document(s)..."
  
  {
    operation: :edit,
    files: context.files,
    instructions: context.user_input
  }
end

def execute_analysis(context)
  return { error: "No document provided for analysis" } if context.files.empty?
  
  emit "Analyzing #{context.files.count} document(s)..."
  
  if CONSTANTS[:generate_summary]
    emit "Generating summary..."
  end
  
  {
    operation: :analyze,
    files: context.files,
    include_summary: CONSTANTS[:generate_summary],
    include_metadata: CONSTANTS[:include_metadata]
  }
end

def execute_conversion(context)
  return { error: "No document provided for conversion" } if context.files.empty?
  
  target_format = detect_target_format(context.user_input)
  
  emit "Converting to #{target_format.upcase}..."
  
  {
    operation: :convert,
    files: context.files,
    target_format: target_format,
    preserve_formatting: CONSTANTS[:preserve_formatting]
  }
end

def execute_batch(context)
  return { error: "No documents provided for batch processing" } if context.files.empty?
  
  # Detect what to do with each file
  sub_operation = OPERATION_PATTERNS.find { |op, pattern| 
    op != :batch && context.user_input.match?(pattern) 
  }&.first || :analyze
  
  emit "Batch processing #{context.files.count} files (#{sub_operation})..."
  
  load_cookbook("batch_processing")
  
  results = context.files.map do |file|
    emit "Processing: #{file.name}"
    { file: file.name, operation: sub_operation }
  end
  
  {
    operation: :batch,
    sub_operation: sub_operation,
    results: results
  }
end

#===============================================================================
# OUTPUT GENERATION
#===============================================================================

def generate_output(result, context)
  if result[:error]
    load_prompt("error_message")
    emit result[:error]
    return
  end
  
  # Select output template
  template = case result[:operation]
  when :analyze
    "output_report"
  when :batch
    "output_report"
  else
    "output_summary"
  end
  
  load_prompt(template)
  
  emit "Operation complete: #{result[:operation]}"
  
  if CONSTANTS[:include_metadata]
    emit "Include metadata in output."
  end
  
  render_result(result)
end

def render_result(result)
  # Template rendering handled by Claude after loading prompt
  result
end
```

## Cookbook Files

### cookbook/creation.md

```markdown
# Document Creation Workflow

## Process

1. **Understand Requirements**
   - Document type (report, letter, article, etc.)
   - Target audience
   - Desired length and structure
   - Formatting requirements

2. **Generate Structure**
   - Create outline based on requirements
   - Identify sections and subsections
   - Plan content flow

3. **Create Content**
   - Write each section
   - Maintain consistent tone
   - Apply formatting as specified

4. **Quality Check**
   - Review for completeness
   - Check formatting consistency
   - Verify requirements met

## Output Formats

| Format | Best For |
|--------|----------|
| DOCX | Editable documents, collaboration |
| PDF | Final distribution, printing |
| MD | Technical docs, version control |
| HTML | Web publishing |
```

### cookbook/analysis.md

```markdown
# Document Analysis Workflow

## Analysis Types

### Content Analysis
- Main topics and themes
- Key points extraction
- Argument structure
- Sentiment assessment

### Structure Analysis
- Document organization
- Section breakdown
- Heading hierarchy
- Length statistics

### Quality Analysis
- Readability score
- Grammar issues
- Consistency check
- Completeness assessment

## Output

Provide structured analysis report with:
1. Executive summary
2. Detailed findings by category
3. Recommendations (if applicable)
4. Metadata (word count, pages, etc.)
```

## Prompt Templates

### prompts/output_report.md

```markdown
# Analysis Report

## Summary
{{summary}}

## Key Findings

### Content
{{content_findings}}

### Structure
{{structure_findings}}

### Quality
{{quality_findings}}

## Metadata
- **Word Count**: {{word_count}}
- **Pages**: {{page_count}}
- **Reading Time**: {{reading_time}}

## Recommendations
{{recommendations}}
```

### prompts/error_message.md

```markdown
# Unable to Process

{{error_description}}

## Suggestions

{{suggestions}}

## Supported Operations
- Create new documents
- Edit existing documents  
- Analyze document content
- Convert between formats
- Batch process multiple files

## Supported Formats
Input: PDF, DOCX, DOC, TXT, MD, HTML, RTF
Output: PDF, DOCX, TXT, MD, HTML
```

## Tool Files

### tools/validator.rb

```ruby
# Document Validator

def validate_document(file, options = {})
  errors = []
  warnings = []
  
  # Size check
  if file.size > options[:max_size]
    errors << "File exceeds maximum size"
  end
  
  # Format check
  unless options[:allowed_formats].include?(file.extension)
    errors << "Unsupported format: #{file.extension}"
  end
  
  # Content check (if readable)
  if file.content.empty?
    warnings << "Document appears to be empty"
  end
  
  {
    valid: errors.empty?,
    errors: errors,
    warnings: warnings
  }
end

def validate_output(content, format)
  case format
  when :docx
    validate_docx_structure(content)
  when :pdf
    validate_pdf_structure(content)
  else
    { valid: true }
  end
end
```

This complete example demonstrates:
- CONSTANTS for configuration
- Pattern-based operation detection
- Conditional cookbook loading
- Dynamic tool loading based on file types
- Multi-step workflow execution
- Error handling throughout
- Template-based output generation
