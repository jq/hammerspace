require 'forwardable'

module Hammerspace

  class Hash
    extend Forwardable
    include Enumerable

    attr_reader :path
    attr_reader :options

    attr_reader :backend

    # TODO: will need to include all of the methods that ruby's Hash supports,
    # or at least Enumerable
    def_delegators :backend,
      :[],
      :[]=,
      :close,
      :delete,
      :each,
      :empty?,
      :has_key?,
      :keys,
      :size,
      :values

    alias_method :key?, :has_key?
    alias_method :include?, :has_key?
    alias_method :length, :size

    DEFAULT_OPTIONS = {
      :backend        => Hammerspace::Backend::Sparkey
    }

    def initialize(path, options={})
      @path    = path
      @options = DEFAULT_OPTIONS.merge(options)

      construct_backend
    end

    def has_value?(value)
      !!find { |k,v| v == value }
    end
    alias_method :member?, :has_value?

    private

    def construct_backend
      @backend = options[:backend].new(path, options)
    end

  end

end
