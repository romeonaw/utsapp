<?php 
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pekerjaan";

$conn = new mysqli($servername, $username, $password,
$dbname);
if ($conn->connect_error) {
die("Koneksi ke database gagal: " . $conn->connect_error);
}

$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
// Mengambil data pekerjaan
$sql = "SELECT * FROM pekerjaan";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
$pekerjaan = array();
while ($row = $result->fetch_assoc()) {
$pekerjaan[] = $row;
}
echo json_encode($pekerjaan);
} else {
echo "Data Pekerjaan kosong.";
}
}

if ($method === "POST") {
    // Menambahkan data mahasiswa
   $data = json_decode(file_get_contents("php://input"), true);
   $nama = $data["nama pekerjaan"];
   $status = $data["status pekerjaan"];
   $sql = "INSERT INTO pekerjaan (nama, status pekerjaan) VALUES ('$nama', '$status')";
   if ($conn->query($sql) === TRUE) {
   $data['pesan'] = 'berhasil';
   //echo "Berhasil tambah data";
   } else {
   $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
   }
   echo json_encode($data);
   }

if ($method === "PUT") {
 // Memperbarui data mahasiswa
$data = json_decode(file_get_contents("php://input"), true);
$id = $data["id"];
$nama = $data["nama pekerjaan"];
$status = $data["status pekerjaan"];
$sql = "UPDATE pekerjaan SET nama='$nama', status pekerjaan='$status' WHERE id=$id";
if ($conn->query($sql) === TRUE) {
} else {
echo "Error: " . $sql . "<br>" . $conn->error;
}
}

if ($method === "DELETE") {
    // Menghapus data mahasiswa
   $id = $_GET["id"];
   $sql = "DELETE FROM pekerjaan WHERE id=$id";
   if ($conn->query($sql) === TRUE) {
   $data['pesan'] = 'berhasil';
   } else {
   $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
   }
   echo json_encode($data);
   }
   
$conn->close()   

?>