namespace GestionAlmacen
{
    public static class Sesion
    {
        public static int    IdUsuario     { get; set; }
        public static string NombreUsuario { get; set; }
        public static string Rol           { get; set; }

        public static bool EsAdministrador
        {
            get { return Rol == "Administrador"; }
        }

        public static void Cerrar()
        {
            IdUsuario = 0;
            NombreUsuario = null;
            Rol = null;
        }
    }
}
