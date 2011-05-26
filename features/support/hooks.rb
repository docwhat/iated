
# Before each scenerio
Before do
  IATed::reset
  IATed::mcp.ui = :test
end

After do
  # This cleans up test directories.
  IATed::reset
end
