# encoding: utf-8

module Communist

  # Provides a dummy server.
  class NullServer
    def method_missing(*)
      return nil
    end

    def nil?; true; end
  end

end # Communist
