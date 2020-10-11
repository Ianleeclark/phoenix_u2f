defmodule Mix.Tasks.U2fMigrate do
  use Mix.Task

  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator
  import Mix.Ecto
  alias Ecto.Migrator

  @shortdoc "Runs the migration to store U2F keys"
  def run(_) do
    config = (Application.get_all_env(:phoenix_u2f) ++ [timestamp: timestamp()]) |> Map.new()

    do_gen_migration(config, "u2f_keys", fn repo, _path, file, name ->
      change = """
              create table(:u2f_keys) do
                  add(:public_key, :string, size: 128, nullable: false)
                  add(:key_handle, :string, size: 128, nullable: false)
                  add(:version, :string, size: 10, default: "U2F_V2")
                  add(:app_id, :string, nullable: false)
                  # NOTE: You'll need to update what table this references or change it to a normal field
                  add(:user_id, :string, nullable: false)
                  timestamps()
              end
              create index(:u2f_keys, [:public_key])
              create unique_index(:u2f_keys, [:user_id])
      """

      assigns = [mod: Module.concat([repo, Migrations, Macro.camelize(name)]), change: change]

      create_file(file, migration_template(assigns))
    end)
  end

  defp do_gen_migration(%{timestamp: current_timestamp} = config, name, fun) do
    # Shamelessly stolen from Coherence
    # https://github.com/smpallen99/coherence/blob/master/lib/mix/tasks/coh.install.ex
    repo = config[:repo]

    ensure_repo(repo, [])

    path =
      case config[:migration_path] do
        path when is_binary(path) ->
          path

        _ ->
          Path.relative_to(Migrator.migrations_path(repo), Mix.Project.app_path())
      end

    file = Path.join(path, "#{current_timestamp}_#{underscore(name)}.exs")
    fun.(repo, path, file, name)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  embed_template(:migration, """
  defmodule <%= inspect @mod %> do
      use Ecto.Migration
      def change do
  <%= @change %>
      end
  end
  """)
end
