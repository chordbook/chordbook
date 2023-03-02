# This is a base class for jobs that run Node scripts.
class NodeJob < ApplicationJob
  class_attribute :script_path

  class Error < StandardError
    attr_reader :data

    def initialize(data)
      super(data["message"])
      @data = data
      exception.set_backtrace(data["stack"].split("\n").slice(1..-1))
    end

    # Generate a new subclass for each JavaScript error.
    def self.generate(data)
      dynamic_name = data["name"]
      const_set(dynamic_name, Class.new(self)) unless const_defined?(dynamic_name)
      const_get(dynamic_name).new(data)
    end
  end

  def perform(stdin = nil)
    stdout, stderr, status = Open3.capture3("node", script_path, {stdin_data: stdin})

    if status.success?
      JSON.parse(stdout)
    else
      raise Error.generate(JSON.parse(stderr))
    end
  end
end
