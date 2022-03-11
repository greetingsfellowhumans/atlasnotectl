defmodule Atlas.Queries.Main do
  import Ecto.Query, warn: false
  alias Atlas.Repo
  use Norm
  alias Atlas.Accounts.{Tech, User}

  def all_by!(schema, clauses) do
    from(item in schema, where: ^clauses, select: item)
    |> Repo.all()
  end


  def get_current_tech(session) do
    case get_current_user(session) do
      {:ok, user} -> 
        case Repo.get_by(Tech, user_id: user.id) do
          %Tech{} = tech -> {:ok, tech}
          err -> err
        end
      err -> err
    end
  end
  def get_current_tech!(session) do
    {:ok, tech} = get_current_tech(session)
    tech
  end


  defp get_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
        %User{} = user <- Atlas.Accounts.get_user_by_session_token(user_token) do
        {:ok, user}
    end
  end
end
