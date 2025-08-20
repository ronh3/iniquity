function iniquity_expdiag(e, method, who, ...)
  local s = targetting(who)
  local afflictions = {...}
  if method == "afflict" then
    for _, aff in ipairs(afflictions) do
      s:afflict(aff)
    end
  elseif method == "afflict smart" then
    s:afflict(...)
  elseif method == "confirm" then
    s:confirm(afflictions[1])
  elseif method == "defstrip" then
    s.defences[afflictions[1]] = nil
  end
end