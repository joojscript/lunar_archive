# Setup database
ExUnit.start()
Lunar.Repo.start_link()

# Remove tmp database:
tmp_database_path = "/tmp/lunar_test.sqlite3"
if File.exists?(tmp_database_path) do
  File.rm!(tmp_database_path)
end
