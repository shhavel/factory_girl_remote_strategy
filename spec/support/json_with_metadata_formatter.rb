class JsonWithMetadataFormatter
  include ActiveResource::Formats::JsonFormat

  ##
  # Since usual JSON from Facewatch has multiple root keys, such as object and _metadata
  #
  # {
  #   "incident": {"id": 1, ...},
  #   "_metadata": {"abilities": ['eat_cookies']}
  # }
  #
  # To be able to get object with its params just after AResObject.find(..), we remove _metadata
  # root key for now since we do not use it internally in APIs
  #
  def decode(json)
    decoded_json = ActiveSupport::JSON.decode(json)
    iterate_by_nodes(decoded_json)
    ActiveResource::Formats.remove_root(decoded_json)
  end

  def iterate_by_nodes(json)
    iterate_by_array(json) if json.is_a? Array

    iterate_by_hash(json) if json.is_a? Hash
  end

  private

  def iterate_by_hash(hash)
    hash.delete('_metadata')

    hash.each_pair do |k, v|
      iterate_by_nodes(v)
    end
  end

  def iterate_by_array(array)
    array.each do |item|
      iterate_by_nodes(item)
    end
  end
end
