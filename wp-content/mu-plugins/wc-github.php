<?php
add_action(
	'woocommerce_order_status_changed',
	function ( $order_id, $old_status, $new_status, $order ) {
		if ( 'production' !== wp_get_environment_type() ) {
			return;
		}

		if ( 'processing' !== $new_status ) {
			return;
		}

		// Check if the order has the product.
		$product_id = 58;
		$items      = $order->get_items();

		$product_in_order = array_filter(
			$items,
			function ( $item ) use ( $product_id ) {
				return $item->get_product_id() === $product_id;
			}
		);

		if ( empty( $product_in_order ) ) {
			return;
		}

		// Get the billing_website order meta
		$billing_website = trim( $order->get_meta( 'billing_website' ), ' /' );

		// Get order email
		$order_email = $order->get_billing_email();

		// Send data to github API via wp_remote_post()
		$github_api_url = 'https://api.github.com/repos/hokoo/cf7-telegram-mediafiles/dispatches';
		$data           = [
			'event_type'    => 'build',
			'client_payload'=> [
				'email'     => $order_email,
				'siteurl'   => $billing_website,
				'orderid'   => $order_id,
			]
		];

		$headers = [
			'Accept' => 'application/vnd.github.v3+json',

			// Authorization
			'Authorization' => 'Bearer ' . ITRON_GITHUB_API_TOKEN,
		];

		$response = wp_remote_post(
			$github_api_url,
			[
				'headers' => $headers,
				'body'    => wp_json_encode( $data ),
			]
		);
	},
	10,
	4
);
