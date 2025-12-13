# Skill Authoring Helpers
#
# Common utilities for Ruby-based skill definitions.
# Include in skill.rb with: require_relative 'tools/helpers'

module SkillHelpers
  #=============================================================================
  # Input Analysis
  #=============================================================================
  
  # Detect intent from user input
  # @param input [String] User's input text
  # @param intent_map [Hash] Pattern => intent mapping
  # @return [Symbol, nil] Detected intent or nil
  def detect_intent(input, intent_map)
    intent_map.each do |intent, patterns|
      patterns = [patterns] unless patterns.is_a?(Array)
      patterns.each do |pattern|
        return intent if input.match?(pattern)
      end
    end
    nil
  end
  
  # Extract entities from input
  # @param input [String] User's input text
  # @param entity_patterns [Hash] Entity type => pattern mapping
  # @return [Hash] Extracted entities
  def extract_entities(input, entity_patterns)
    entities = {}
    entity_patterns.each do |entity_type, pattern|
      matches = input.scan(pattern).flatten
      entities[entity_type] = matches unless matches.empty?
    end
    entities
  end
  
  # Calculate input complexity score
  # @param input [String] User's input text
  # @return [Symbol] :simple, :moderate, or :complex
  def assess_complexity(input)
    word_count = input.split.count
    sentence_count = input.split(/[.!?]/).count
    has_lists = input.match?(/\d+\.|[-*•]/)
    has_code = input.match?(/```|`[^`]+`/)
    
    score = 0
    score += 1 if word_count > 50
    score += 1 if word_count > 200
    score += 1 if sentence_count > 5
    score += 1 if has_lists
    score += 1 if has_code
    
    case score
    when 0..1 then :simple
    when 2..3 then :moderate
    else :complex
    end
  end
  
  #=============================================================================
  # File Handling
  #=============================================================================
  
  # Categorize files by type
  # @param files [Array<FileWrapper>] List of files
  # @return [Hash] Category => files mapping
  def categorize_files(files)
    categories = {
      documents: %w[.pdf .docx .doc .txt .md .rtf .odt],
      spreadsheets: %w[.xlsx .xls .csv .tsv],
      images: %w[.png .jpg .jpeg .gif .svg .webp],
      code: %w[.rb .py .js .ts .java .go .rs .c .cpp],
      data: %w[.json .xml .yaml .yml],
      archives: %w[.zip .tar .gz .rar]
    }
    
    result = Hash.new { |h, k| h[k] = [] }
    
    files.each do |file|
      ext = file.extension.downcase
      category = categories.find { |_, exts| exts.include?(ext) }&.first || :other
      result[category] << file
    end
    
    result
  end
  
  # Check if file type is supported
  # @param file [FileWrapper] File to check
  # @param supported [Array<String>] Supported extensions
  # @return [Boolean]
  def supported_file?(file, supported)
    ext = file.extension.delete('.').downcase
    supported.map(&:downcase).include?(ext)
  end
  
  #=============================================================================
  # Workflow Control
  #=============================================================================
  
  # Execute steps with error handling
  # @param steps [Array<Symbol>] Step method names
  # @param context [Context] Execution context
  # @return [Hash] Result with status and data
  def execute_workflow(steps, context)
    data = {}
    
    steps.each_with_index do |step, index|
      emit "Step #{index + 1}/#{steps.count}: #{step}"
      
      begin
        result = send(step, context, data)
        data.merge!(result) if result.is_a?(Hash)
      rescue StandardError => e
        return {
          status: :failed,
          failed_step: step,
          error: e.message,
          completed_steps: steps[0...index]
        }
      end
    end
    
    { status: :success, data: data }
  end
  
  # Retry operation with backoff
  # @param max_attempts [Integer] Maximum retry attempts
  # @param operation [Proc] Operation to retry
  # @return [Object] Operation result
  def with_retry(max_attempts: 3, &operation)
    attempts = 0
    
    begin
      attempts += 1
      operation.call
    rescue RetryableError => e
      if attempts < max_attempts
        emit "Attempt #{attempts} failed, retrying..."
        retry
      else
        raise e
      end
    end
  end
  
  # Gate execution on a condition
  # @param condition [Boolean] Gate condition
  # @param message [String] Message if gate fails
  # @return [Boolean] Whether gate passed
  def gate(condition, message)
    unless condition
      emit "Gate failed: #{message}"
      return false
    end
    true
  end
  
  #=============================================================================
  # Output Formatting
  #=============================================================================
  
  # Format as markdown table
  # @param headers [Array<String>] Column headers
  # @param rows [Array<Array>] Table rows
  # @return [String] Markdown table
  def markdown_table(headers, rows)
    lines = []
    lines << "| #{headers.join(' | ')} |"
    lines << "| #{headers.map { |_| '---' }.join(' | ')} |"
    rows.each do |row|
      lines << "| #{row.join(' | ')} |"
    end
    lines.join("\n")
  end
  
  # Format as bullet list
  # @param items [Array<String>] List items
  # @param indent [Integer] Indentation level
  # @return [String] Markdown list
  def bullet_list(items, indent: 0)
    prefix = '  ' * indent + '- '
    items.map { |item| "#{prefix}#{item}" }.join("\n")
  end
  
  # Format as numbered list
  # @param items [Array<String>] List items
  # @return [String] Markdown numbered list
  def numbered_list(items)
    items.each_with_index.map { |item, i| "#{i + 1}. #{item}" }.join("\n")
  end
  
  # Wrap text in code block
  # @param code [String] Code content
  # @param language [String] Language identifier
  # @return [String] Markdown code block
  def code_block(code, language: '')
    "```#{language}\n#{code}\n```"
  end
  
  #=============================================================================
  # Validation Helpers
  #=============================================================================
  
  # Validate required fields
  # @param data [Hash] Data to validate
  # @param required [Array<Symbol>] Required field names
  # @return [Hash] Validation result
  def validate_required(data, required)
    missing = required.select { |field| data[field].nil? || data[field].to_s.empty? }
    {
      valid: missing.empty?,
      missing: missing
    }
  end
  
  # Validate field types
  # @param data [Hash] Data to validate
  # @param type_map [Hash] Field => expected type mapping
  # @return [Hash] Validation result
  def validate_types(data, type_map)
    errors = []
    type_map.each do |field, expected_type|
      value = data[field]
      next if value.nil?
      unless value.is_a?(expected_type)
        errors << "#{field}: expected #{expected_type}, got #{value.class}"
      end
    end
    { valid: errors.empty?, errors: errors }
  end
  
  # Validate with custom rules
  # @param data [Hash] Data to validate
  # @param rules [Hash] Field => validation proc mapping
  # @return [Hash] Validation result
  def validate_custom(data, rules)
    errors = []
    rules.each do |field, validator|
      value = data[field]
      result = validator.call(value)
      errors << "#{field}: #{result}" if result.is_a?(String)
    end
    { valid: errors.empty?, errors: errors }
  end
end

# Custom error for retryable operations
class RetryableError < StandardError; end
