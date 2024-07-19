mod middleware;
mod handlers;

use actix_web::{web, App, HttpServer};
use actix_web_httpauth::middleware::HttpAuthentication;
use aws_sdk_s3::{Client, Region};
use dotenv::dotenv;
use std::env;
use handlers::{upload_file, fetch_file, AppState};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::init();

    let aws_access_key_id = env::var("AWS_ACCESS_KEY_ID").expect("AWS_ACCESS_KEY_ID not set");
    let aws_secret_access_key = env::var("AWS_SECRET_ACCESS_KEY").expect("AWS_SECRET_ACCESS_KEY not set");
    let aws_region = env::var("AWS_REGION").expect("AWS_REGION not set");
    let s3_bucket_name = env::var("S3_BUCKET_NAME").expect("S3_BUCKET_NAME not set");

    let shared_config = aws_config::from_env()
        .region(Region::new(aws_region))
        .credentials_provider(aws_sdk_s3::Credentials::from_keys(
            aws_access_key_id,
            aws_secret_access_key,
            None,
        ))
        .load()
        .await;

    let s3_client = Client::new(&shared_config);

    let app_state = web::Data::new(AppState {
        s3_client,
        bucket_name: s3_bucket_name,
    });

    HttpServer::new(move || {
        App::new()
            .app_data(app_state.clone())
            .wrap(HttpAuthentication::bearer(middleware::validate_jwt))
            .service(
                web::scope("/storage")
                    .route("/upload", web::post().to(upload_file))
                    .route("/fetch/{file_key}", web::get().to(fetch_file))
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
