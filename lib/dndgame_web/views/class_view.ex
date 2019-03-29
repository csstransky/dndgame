defmodule DndgameWeb.ClassView do
  use DndgameWeb, :view
  alias DndgameWeb.ClassView

  def render("index.json", %{classes: classes}) do
    %{data: render_many(classes, ClassView, "class.json")}
  end

  def render("show.json", %{class: class}) do
    %{data: render_one(class, ClassView, "class.json")}
  end

  def render("class.json", %{class: class}) do
    %{id: class.id,
      name: class.name,
      desc: class.desc,
      hit_die: class.hit_die}
  end
end
