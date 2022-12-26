bd: 
	docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=yourStrong(#)Password" -p 1433:1433 --name mssql -d mcr.microsoft.com/mssql/server:2022-latest
	sleep 30
	docker exec -it mssql mkdir /usr/sqlsetup

	docker cp bd.sql mssql:/usr/sqlsetup/setup.sql

	docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "yourStrong(#)Password" -i /usr/sqlsetup/setup.sql

exec:
	docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -H localhost -U sa -P "yourStrong(#)Password" -d "bd"

rm:
	docker rm -f mssql
