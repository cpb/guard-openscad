class Hash
  def except(*delete_keys)
    remaining_keys = keys - delete_keys
    Hash[remaining_keys.zip(values_at(*remaining_keys))]
  end
end
