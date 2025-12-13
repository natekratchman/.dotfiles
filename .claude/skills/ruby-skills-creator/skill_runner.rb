# Skill Runner - Ruby Skill Interpretation Framework
#
# This module provides the DSL methods available to skill.rb files.
# Claude interprets these methods conceptually when processing skills.
#
# IMPORTANT: This is a conceptual framework. Claude does not execute Ruby
# directly but understands the semantics to determine workflow routing.

module SkillRunner
  # Context object passed to execute()
  class Context
    attr_reader :user_input, :files, :conversation, :metadata
    
    def initialize(user_input:, files: [], conversation: [], metadata: {})
      @user_input = user_input
      @files = files.map { |f| FileWrapper.new(f) }
      @conversation = conversation
      @metadata = metadata
    end
  end
  
  # Wrapper for uploaded files
  class FileWrapper
    attr_reader :name, :path, :size, :content
    
    def initialize(file_data)
      @name = file_data[:name]
      @path = file_data[:path]
      @size = file_data[:size]
      @content = file_data[:content]
    end
    
    def extension
      File.extname(@name).downcase
    end
    
    def basename
      File.basename(@name, extension)
    end
  end
  
  #=============================================================================
  # DSL Methods - Available to skill.rb files
  #=============================================================================
  
  module DSL
    # Load a cookbook file into context
    # @param name [String] Cookbook name (without path/extension)
    # @return [String] Contents of the cookbook file
    def load_cookbook(name)
      path = "cookbook/#{name}.md"
      read_file(path)
    end
    
    # Load a prompt template
    # @param name [String] Prompt name (without path/extension)
    # @return [String] Contents of the prompt file
    def load_prompt(name)
      path = "prompts/#{name}.md"
      read_file(path)
    end
    
    # Load a tool script for execution
    # @param path [String] Relative path to tool
    # @return [void]
    def load_tool(path)
      # Tool loading registers the tool for potential execution
      # Claude reads the tool to understand its capabilities
      read_file(path)
    end
    
    # Load reference documentation
    # @param name [String] Reference name (without path/extension)
    # @return [String] Contents of the reference file
    def load_reference(name)
      path = "references/#{name}.md"
      read_file(path)
    end
    
    # Read any file from the skill directory
    # @param path [String] Relative path from skill root
    # @return [String] File contents
    def read_file(path)
      # In practice, Claude reads the file at this path
      # Returns file contents as string
      File.read(path)
    end
    
    # Emit an instruction or message to Claude's output
    # @param message [String] Message to emit
    # @return [void]
    def emit(message)
      # Emitted messages become part of Claude's working instructions
      puts message
    end
    
    # Request clarification from the user
    # @param question [String] Question to ask
    # @return [String] User's response (in next turn)
    def ask_user(question)
      emit "CLARIFICATION NEEDED: #{question}"
    end
    
    # Render a template with variables
    # @param template [String] Template content with {{variable}} placeholders
    # @param vars [Hash] Variables to interpolate
    # @return [String] Rendered template
    def render(template, vars)
      result = template.dup
      vars.each do |key, value|
        result.gsub!("{{#{key}}}", value.to_s)
      end
      result
    end
    
    # Validate data against a schema
    # @param data [Object] Data to validate
    # @param schema [Hash] Validation schema
    # @return [Hash] Validation result with :valid and :errors
    def validate(data, schema)
      errors = []
      
      schema.each do |field, rules|
        value = data[field]
        
        if rules[:required] && value.nil?
          errors << "#{field} is required"
        end
        
        if rules[:type] && !value.nil?
          unless value.is_a?(rules[:type])
            errors << "#{field} must be #{rules[:type]}"
          end
        end
        
        if rules[:pattern] && value.is_a?(String)
          unless value.match?(rules[:pattern])
            errors << "#{field} format invalid"
          end
        end
      end
      
      { valid: errors.empty?, errors: errors }
    end
    
    # Execute a loaded tool with arguments
    # @param tool_name [Symbol] Tool identifier
    # @param args [Hash] Arguments to pass
    # @return [Object] Tool result
    def execute_tool(tool_name, **args)
      # Claude executes the tool conceptually
      # Results depend on the specific tool
      { tool: tool_name, args: args, status: :executed }
    end
    
    # Check if a file exists in the skill directory
    # @param path [String] Relative path to check
    # @return [Boolean]
    def file_exists?(path)
      File.exist?(path)
    end
    
    # List files in a skill subdirectory
    # @param directory [String] Directory to list
    # @return [Array<String>] File names
    def list_files(directory)
      Dir.glob("#{directory}/*").map { |f| File.basename(f) }
    end
  end
  
  #=============================================================================
  # Skill Execution
  #=============================================================================
  
  class Executor
    include DSL
    
    attr_reader :skill_path, :constants
    
    def initialize(skill_path)
      @skill_path = skill_path
      @constants = {}
    end
    
    # Load and prepare a skill for execution
    def load_skill
      skill_rb = File.join(@skill_path, 'skill.rb')
      
      unless File.exist?(skill_rb)
        raise "skill.rb not found in #{@skill_path}"
      end
      
      # Load the skill definition
      instance_eval(File.read(skill_rb))
      
      # Extract CONSTANTS if defined
      @constants = self.class.const_get(:CONSTANTS) rescue {}
      
      self
    end
    
    # Execute the skill with given context
    def run(context)
      unless respond_to?(:execute)
        raise "Skill must define execute(context) method"
      end
      
      execute(context)
    end
  end
  
  #=============================================================================
  # Helper Methods for Skill Authors
  #=============================================================================
  
  module Helpers
    # Pattern matching helper for routing
    def match_any?(input, patterns)
      patterns.any? { |p| input.match?(p) }
    end
    
    # Extract keywords from input
    def extract_keywords(input)
      input.downcase.scan(/\b\w+\b/).uniq
    end
    
    # Determine confidence score for a match
    def match_confidence(input, pattern)
      matches = input.scan(pattern)
      [matches.length / 10.0, 1.0].min
    end
    
    # Safe hash access with defaults
    def fetch_config(key, default = nil)
      CONSTANTS.fetch(key, default)
    end
    
    # Batch process with progress tracking
    def process_batch(items, &block)
      total = items.count
      items.each_with_index.map do |item, index|
        emit "Processing #{index + 1}/#{total}..."
        block.call(item, index)
      end
    end
  end
end

#===============================================================================
# Usage Example
#===============================================================================

if __FILE__ == $0
  # Example: Load and run a skill
  executor = SkillRunner::Executor.new('.claude/skills/my-skill')
  executor.load_skill
  
  context = SkillRunner::Context.new(
    user_input: "Analyze this document for key themes",
    files: [
      { name: "report.pdf", path: "/uploads/report.pdf", size: 1024000 }
    ]
  )
  
  result = executor.run(context)
  puts "Result: #{result.inspect}"
end
