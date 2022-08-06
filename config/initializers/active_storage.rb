# Proxy requests to active_storage blobs. This allows for much better caching
# and requires one less round-trip. Since we store images on disk anyway, this
# should not have any performance impact.
Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy
