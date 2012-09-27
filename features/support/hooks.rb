
# Before each scenerio
Before do
  Iated::reset
  Iated::mcp.ui = :test
end

After do
  # This cleans up test directories.
  Iated::reset
end
