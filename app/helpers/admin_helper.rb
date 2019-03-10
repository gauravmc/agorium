module AdminHelper
  def options_for_state_select(selected)
    states_hash = Brand::INDIAN_STATES.each_with_object({}) { |k, h| h[k] = k }
    options_for_select(states_hash, selected)
  end
end
