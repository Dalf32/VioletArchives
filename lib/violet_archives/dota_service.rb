require 'json'
require 'open-uri'

module VioletArchives
  # Retrieves data from the DotA 2 API
  class DotaService
    def initialize(service_urls, **opts)
      @service_urls = service_urls
      @opts = opts
    end

    def patch_list
      retrieve_data(@service_urls.patch_list)
    end

    def patch_notes(patch_num)
      retrieve_data(@service_urls.patch_notes(patch_num))
    end

    def item_list
      retrieve_data(@service_urls.item_list)
    end

    def ability_list
      retrieve_data(@service_urls.ability_list)
    end

    def hero_list
      retrieve_data(@service_urls.hero_list)
    end

    def item_data(item_id)
      retrieve_data(@service_urls.item_data(item_id))
    end

    def ability_data(ability_id)
      retrieve_data(@service_urls.ability_data(ability_id))
    end

    def hero_data(hero_id)
      retrieve_data(@service_urls.hero_data(hero_id))
    end

    private

    def retrieve_data(request_url)
      data_raw = URI.open(request_url, **@opts)
      JSON.parse(data_raw.readlines.join)
    end
  end
end
