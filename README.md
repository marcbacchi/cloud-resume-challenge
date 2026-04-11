# Cloud Resume Challenge

My online resume, live at [marcbacchi.dev](https://www.marcbacchi.dev) — a static site built from scratch with HTML and CSS, backed by a serverless visitor counter.

See the [Dev.to write-up](https://dev.to/marcbacchi/cloud-resume-built-for-a-challenge-4m8p) for a full walkthrough of the project.

---

## How it works

A push to `main` triggers the GitHub Actions pipeline:

1. **Terraform** — provisions or updates all AWS infrastructure (`terraform init` + `terraform apply`)
2. **S3 sync** — uploads the resume site files to the S3 origin bucket
3. **Smoke tests** — curl checks that the site returns HTTP 200 and expected content

### Visitor counter flow

```
Browser → CloudFront → S3 (serves index.html)
                ↓ (new visitor, JS fetch)
         API Gateway → Lambda (Python) → DynamoDB (atomic increment)
                                ↓
                         returns { count: N }
```

- Cookie-based deduplication: returning visitors within 30 days read a cached count from `localStorage` without hitting the API
- The Lambda uses a single atomic `update_item` call (`ADD visitcount :1`, `ReturnValues=ALL_NEW`) — no separate read needed

---

## AWS architecture

![AWS Services Diagram](https://user-images.githubusercontent.com/98762800/156835852-d4388868-afae-4ee7-91a6-139b3372e9c5.png)

| Service | Role |
|---|---|
| S3 | Hosts static site files; separate bucket redirects `marcbacchi.dev` → `www.marcbacchi.dev` |
| CloudFront | HTTPS termination, CDN, enforces redirect-to-https on both distributions |
| Route 53 | DNS hosted zone, A records aliased to CloudFront distributions |
| ACM | SSL/TLS certificate for `marcbacchi.dev` and `www.marcbacchi.dev` (DNS validated) |
| API Gateway v2 | HTTP API endpoint, proxies requests to Lambda |
| Lambda | Python 3.11 — increments and returns visitor count |
| DynamoDB | Single-item counter table (provisioned, 1 RCU / 1 WCU) |
| IAM | Least-privilege role: Lambda may only write CloudWatch logs and call `UpdateItem` |

---

## Infrastructure

All AWS resources are provisioned by Terraform. No manual console setup.

```
providers.tf      — AWS provider, S3 backend (marcbacchidev-terraform)
variables.tf      — domain_name, bucket_name, common_tags
s3.tf             — www bucket (static site) + root bucket (redirect)
cloudfront.tf     — two distributions: www site and root redirect
route53.tf        — hosted zone, A records, ACM validation records
acm.tf            — SSL certificate + DNS validation
dynamodb.tf       — counter table
lambda.tf         — function packaging and deployment
api.tf            — API Gateway v2 + Lambda integration + permission
lambda-iam.tf     — IAM role and inline policy
outputs.tf        — API endpoint, CloudFront domains, website URL
```

## CI/CD

GitHub Actions workflow (`.github/workflows/runworkflow.yml`):

- Triggered on push to `main`
- Uses `actions/checkout@v4` and `hashicorp/setup-terraform@v3`
- S3 sync via custom Docker action (`marcbacchi/cloud-resume-challenge@main`) built on `amazon/aws-cli`
- AWS credentials passed via repository secrets
