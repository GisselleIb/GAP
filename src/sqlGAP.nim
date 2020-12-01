import db_sqlite

proc getCosts*(db:string):seq[seq[string]]=
  let bd=open(db,"","","")
  result=bd.getAllRows(sql"SELECT costo FROM costos" )
  bd.close()
  return result

proc getCapacities*(db:string):seq[seq[string]]=
  let bd=open(db,"","","")
  result=bd.getAllRows(sql"SELECT capacidad FROM capacidades" )
  bd.close()
  return result
