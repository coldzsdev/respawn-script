local respawnTime = 300 -- czas w sekundach, który musi upłynąć przed respawnem

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsEntityDead(GetPlayerPed(-1)) then -- sprawdzamy, czy gracz jest martwy
      local deathTime = GetGameTimer() -- pobieramy czas, w którym gracz umarł
      while IsEntityDead(GetPlayerPed(-1)) do -- czekamy, aż gracz zostanie odrodzony
        Citizen.Wait(0)
      end
      local respawnTimer = respawnTime - (GetGameTimer() - deathTime) -- obliczamy pozostały czas do respawnu
      if respawnTimer > 0 then -- jeśli gracz umarł przed upływem czasu respawnu, to wyświetlamy informację o czasie respawnu
        exports['mythic_notify']:DoCustomHudText('inform', 'Zostałeś(aś) zabity(a), musisz poczekać ' .. respawnTimer .. ' sekund, aby się odrodzić. Naciśnij E, aby się teleportować.', 5000)
        local keyPressed = false -- flaga, która ustawia się na true, gdy gracz naciśnie klawisz E
        Citizen.CreateThread(function()
          while not keyPressed do
            Citizen.Wait(0)
            if IsControlJustReleased(0, 38) then -- sprawdzamy, czy gracz nacisnął klawisz E
              keyPressed = true
            end
          end
        end)
        Citizen.Wait(respawnTimer * 1000) -- czekamy na upłynięcie czasu respawnu
      end
      SetEntityCoords(GetPlayerPed(-1), 298.26, -584.19, 43.27, 0, 0, 0, 0) -- teleportujemy gracza na szpital
      exports['mythic_notify']:DoCustomHudText('success', 'Zostałeś(aś) odrodzony(a) na szpitalu.', 5000)
    end
  end
end)
