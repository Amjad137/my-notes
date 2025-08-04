interface ListingPageProps {
  params: Promise<{
    listingId: string;
  }>;
}

const ListingPage = ({ params }: ListingPageProps) => {

const listingId = use(params).listingId;