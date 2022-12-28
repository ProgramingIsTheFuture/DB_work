let home request (message: (string*int) option) = 
  <div class="container">
    <h1 class="title" style="text-align: center; padding: 30px">Gestão de Projetos UBI</h1>
    <nav>
      <ul class="options">
        <li><a href="/projetos">Projetos / Contratos</a></li>
        <li><a href="/investigadores">Investigadores</a></li>
        <li><a href="/institutos">Institutos</a></li>
        <li><a href="/entidades">Entidades Financiadoras</a></li>
        <li><a href="#">Option 5</a></li>
      </ul>
    </nav>

    <form method="POST" action="/example">
      <%s! Dream.csrf_tag request %>
      <input type="text" name="message" /> 
      <input type="text" name="hello" /> 
      <input type="submit" />
    </form>

% begin match message with 
%   | None -> () 
%   | Some (message, 0) -> 
      <p>Message: <b><%s message %>!</b></p>
%   | Some (message, 1) ->
      <p>Tas lixado: <b><%s message %>!</b></p>
%   end;
  </div>
