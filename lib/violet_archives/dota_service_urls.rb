module VioletArchives
  # Keeps all URLs used by the DotaService
  class DotaServiceUrls
    def initialize(base_url, **service_paths)
      @base_url = base_url
      @base_url += '/' unless @base_url.end_with?('/')

      raise 'Invalid service path key(s)' unless service_paths.keys.all? { |k| k.is_a?(Symbol) }
      raise 'Invalid service path(s)' unless service_paths.values.all? { |v| v.is_a?(String) }

      @service_paths = service_paths
    end

    def <<(path_key, path)
      raise 'Invalid service path key' unless path_key.is_a?(Symbol)
      raise 'Invalid service path' unless path.is_a?(String)

      @service_paths[path_key] = path
      self
    end

    private

    def method_missing(symbol, *args)
      return build_url(method_to_path(symbol), *args) if respond_to_missing?(symbol)

      super
    end

    def respond_to_missing?(symbol, _include_private = false)
      @service_paths.keys.include?(method_to_path(symbol))
    end

    def method_to_path(method)
      "#{method}_path".to_sym
    end

    def build_url(path, *args)
      @base_url + @service_paths[path].delete_prefix('/') + (args.first || '').to_s
    end
  end
end
