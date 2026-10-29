using System;
using System.Windows.Forms;

namespace GestionAlmacen
{
    public partial class FormLogin : Form
    {
        private readonly UsuarioDAL usuarioDAL = new UsuarioDAL();

        public FormLogin()
        {
            InitializeComponent();
        }

        private void btnIngresar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtUsuario.Text) ||
                string.IsNullOrEmpty(txtContrasena.Text))
            {
                MessageBox.Show("Ingrese usuario y contraseña.", "Aviso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                if (usuarioDAL.ValidarLogin(txtUsuario.Text.Trim(), txtContrasena.Text))
                {
                    DialogResult = DialogResult.OK;
                    Close();
                }
                else
                {
                    MessageBox.Show("Usuario o contraseña incorrectos.", "Acceso denegado",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtContrasena.Clear();
                    txtContrasena.Focus();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error de conexión: " + ex.Message, "Error",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}
