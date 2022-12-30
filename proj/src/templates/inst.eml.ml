open Types

let institutos (inst: data list) =
  General.navbar_home "Institutos" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Designação</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <% inst |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/institutos/<%s x<|"id" %>'><%s x<|"designacao" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

let instituto (inst: data list) = 
  General.navbar_inpage "Instituto" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s inst |> List.hd <| "designacao" %></h1>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Docentes</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% inst |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x<|"id" %></th>
            <td><a href='/investigadores/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href='/institutos/<%s inst |> List.hd <| "InstId" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

let inst_form request investigadores =
  General.navbar_inpage "Instituto" ^
  <div class="container" style="width:500px;">
    <p style="margin-bottom: 2rem;"></p>
    <div id="form-fields">
    <form method="POST" action="/institutos/:id/modificar">
      <%s! Dream.csrf_tag request %>
      <div class="input-group">
        <select class="form-select" id="inputGroupSelect04" aria-label="Example select with button addon">
          <option selected>Escolha um investigador: </option>
          <% investigadores |> List.iter begin fun x -> %> 
            <option value='<%s x<|"id" %>'><%s x<|"nome" %></option>
          <% end; %>
        </select>  
        <button class="btn btn-outline-secondary" type="button" onclick="addField()">+</button>
      </div>
    </div>
    </form>
  <script>
    function addField() {
      // Create a new select element
      var select = document.createElement("select");
      select.className = "form-select";
      select.id = "inputGroupSelect04";
      select.setAttribute("aria-label", "Example select with button addon");

      // Create the default "Choose an investigator" option
      var defaultOption = document.createElement("option");
      defaultOption.selected = true;
      defaultOption.text = "Choose an investigator:";
      select.appendChild(defaultOption);

      // Add the options from the existing select element
      var options = document.querySelectorAll("#inputGroupSelect04 > option");
      for (var i = 0; i < options.length; i++) {
        var option = options[i];
        var newOption = document.createElement("option");
        newOption.value = option.value;
        newOption.text = option.text;
        select.appendChild(newOption);
      }

      // Add the select element to the form
      document.getElementById("form-fields").appendChild(select);
    }
  </script>
  </div>
