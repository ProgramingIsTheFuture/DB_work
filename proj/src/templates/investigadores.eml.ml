let investigadores = 
  General.navbar_inpage "Investigadores" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">First</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <tr>
          <th scope="row">1</th>
          <td><a href="/inves_teste">Mark</a></td>
        </tr>
        <tr>
          <th scope="row">2</th>
          <td>Jacob</td>
        </tr>
        <tr>
          <th scope="row">3</th>
          <td>Larry</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="margin: 30px">
    <a href="/index.html" class="btn btn-outline-secondary" tabindex="-1" role="button" aria-disabled="true">
      Adicionar investigador
    </a>
  </div>


