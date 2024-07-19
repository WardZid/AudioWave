use actix_multipart::Multipart;
use actix_web::{web, Error, HttpResponse, Responder};
use aws_sdk_s3::{Client};
use aws_sdk_s3::types::ByteStream;
use futures::StreamExt;
use tokio::fs::File;
use tokio::io::AsyncWriteExt;

#[derive(Clone)]
pub struct AppState {
    pub s3_client: Client,
    pub bucket_name: String,
}

pub async fn upload_file(
    mut payload: Multipart,
    state: web::Data<AppState>,
) -> Result<HttpResponse, Error> {
    let mut file_path = String::new();

    while let Ok(Some(mut field)) = payload.try_next().await {
        let content_disposition = field.content_disposition().unwrap();
        let filename = content_disposition.get_filename().unwrap();
        file_path = format!("/tmp/{}", sanitize_filename::sanitize(&filename));

        let mut f = File::create(&file_path).await?;
        while let Some(chunk) = field.next().await {
            let data = chunk.unwrap();
            f.write_all(&data).await?;
        }
    }

    let file = File::open(&file_path).await?;
    let stream = ByteStream::from_path(file_path.clone()).await?;

    state
        .s3_client
        .put_object()
        .bucket(&state.bucket_name)
        .key(&file_path)
        .body(stream)
        .send()
        .await
        .map_err(|e| {
            log::error!("Failed to upload file: {}", e);
            HttpResponse::InternalServerError().finish()
        })?;

    Ok(HttpResponse::Ok().body("File uploaded successfully"))
}

pub async fn fetch_file(
    web::Path(file_key): web::Path<String>,
    state: web::Data<AppState>,
) -> impl Responder {
    let result = state
        .s3_client
        .get_object()
        .bucket(&state.bucket_name)
        .key(&file_key)
        .send()
        .await;

    match result {
        Ok(output) => {
            let body = output.body.collect().await.unwrap();
            HttpResponse::Ok().body(body)
        }
        Err(e) => {
            log::error!("Failed to fetch file: {}", e);
            HttpResponse::InternalServerError().finish()
        }
    }
}
