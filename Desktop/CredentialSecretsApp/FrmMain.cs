using MongoDB.Bson;
using MongoDB.Driver;
using System.Security.Cryptography;
using Timer = System.Windows.Forms.Timer;

namespace CredentialSecretsApp
{
    public partial class FrmMain : Form
    {
        private Timer _statusTimer;
        private string connectionUri;
        private bool isConnected = false;


        private MongoClient _mongoClient;

        public FrmMain()
        {
            InitializeComponent();


            var loginForm = new FrmLogin();
            while (isConnected == false)
            {
                var dialogResult = loginForm.ShowDialog();

                if (dialogResult == DialogResult.OK)
                {
                    connectionUri = $"mongodb+srv://{loginForm.Username}:{loginForm.Password}@credential-secrets-clus.3wirp.mongodb.net/?retryWrites=true&w=majority&appName=credential-secrets-cluster";
                    InitializeMongoClient();
                    CheckConnection();
                }
                else
                {
                    break;
                }
            }
        }

        private void FrmMain_Load(object sender, EventArgs e)
        {

            if (isConnected)
            {
                _statusTimer = new Timer
                {
                    Interval = 5000 // Set the interval to 5 seconds (5000 milliseconds)
                };
                _statusTimer.Tick += StatusTimer_Tick;
                _statusTimer.Start();
            }
            else
            {
                Application.Exit();
            }
        }

        private void InitializeMongoClient()
        {
            if (!string.IsNullOrEmpty(connectionUri))
            {
                var settings = MongoClientSettings.FromConnectionString(connectionUri);
                settings.ServerApi = new ServerApi(ServerApiVersion.V1);
                _mongoClient = new MongoClient(settings);
            }
            else
            {
                MessageBox.Show("Connection string is not set.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void StatusTimer_Tick(object sender, EventArgs e)
        {
            CheckConnection();
        }

        private void CheckConnection()
        {
            isConnected = PingMongo();

            // Update the label color based on the connection status
            if (isConnected)
            {
                lblConnectionStatus.Text = "Connected";
                lblConnectionStatus.BackColor = Color.MediumSeaGreen;

                btnGenerateKeys.Enabled = true;

                // Fetch the most recent RSA keys
                FetchAndDisplayRsaKeys();
            }
            else
            {
                lblConnectionStatus.Text = "Disconnected";
                lblConnectionStatus.BackColor = Color.LightCoral;

                btnGenerateKeys.Enabled = false;
            }
        }
        private void FetchAndDisplayRsaKeys()
        {
            try
            {
                var database = _mongoClient.GetDatabase("credential-secrets");
                var collection = database.GetCollection<BsonDocument>("rsa-keys");

                // Retrieve the most recent document
                var filter = Builders<BsonDocument>.Filter.Empty;
                var sort = Builders<BsonDocument>.Sort.Descending("createdAt");
                var latestKeys = collection.Find(filter).Sort(sort).FirstOrDefault();

                if (latestKeys != null)
                {
                    // Extract the keys
                    string publicKey = latestKeys.GetValue("publicKey").AsString;
                    string privateKey = latestKeys.GetValue("privateKey").AsString;

                    // Display the keys in TextBoxes or Labels
                    txtPublicKey.Text = publicKey;
                    txtPrivateKey.Text = privateKey;
                }
                else
                {
                    Console.WriteLine("No RSA keys found in the database.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching RSA keys: {ex.Message}");
            }
        }

        private bool PingMongo()
        {
            if (_mongoClient == null)
            {
                Console.WriteLine("MongoClient is not initialized.");
                return false;
            }


            try
            {
                var result = _mongoClient.GetDatabase("credential-secrets").RunCommand<BsonDocument>(new BsonDocument("ping", 1));
                Console.WriteLine("Pinged your deployment. You successfully connected to MongoDB!");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error connecting to MongoDB: {ex.Message}");
            }
            return false;
        }

        private void btnGenerateKeys_Click(object sender, EventArgs e)
        {
            if (isConnected)
                GenerateAndSaveRsaKeys();
        }

        private void GenerateAndSaveRsaKeys()
        {
            try
            {
                using (var rsa = new RSACryptoServiceProvider(2048))
                {
                    rsa.PersistKeyInCsp = false;

                    // Generate public and private keys
                    string publicKey = Convert.ToBase64String(rsa.ExportRSAPublicKey());
                    string privateKey = Convert.ToBase64String(rsa.ExportRSAPrivateKey());

                    txtPublicKey.Text = publicKey;
                    txtPrivateKey.Text = privateKey;

                    // Save the keys to MongoDB
                    var database = _mongoClient.GetDatabase("credential-secrets");
                    var collection = database.GetCollection<BsonDocument>("rsa-keys");

                    var document = new BsonDocument
                    {
                        { "publicKey", publicKey },
                        { "privateKey", privateKey },
                        { "createdAt", DateTime.UtcNow }
                    };

                    collection.InsertOne(document);

                    MessageBox.Show("RSA key pair generated and saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"An error occurred while generating or saving the keys: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

    }
}
