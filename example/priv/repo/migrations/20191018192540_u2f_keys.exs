defmodule Example.Repo.Migrations.U2fKeys do
use Ecto.Migration
def change do
create table(:u2f_keys) do
add(:public_key, :string, size: 128, nullable: false)
add(:key_handle, :string, size: 128, nullable: false)
add(:version, :string, size: 10, default: "U2F_V2")
add(:app_id, :string, nullable: false)
# NOTE: You'll need to update what table this references or change it to a normal field
add(:user_id, :string, nullable: false)

timestamps()
end

end
end
