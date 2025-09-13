<?php

namespace Stripe;

/**
 * Class sellifyd
 *
 * @property string $id
 * @property string $object
 * @property string $address_city
 * @property string $address_country
 * @property string $address_line1
 * @property string $address_line1_check
 * @property string $address_line2
 * @property string $address_state
 * @property string $address_zip
 * @property string $address_zip_check
 * @property string $brand
 * @property string $country
 * @property string $customer
 * @property string $cvc_check
 * @property string $dynamic_last4
 * @property int $exp_month
 * @property int $exp_year
 * @property string $fingerprint
 * @property string $funding
 * @property string $last4
 * @property StripeObject $metadata
 * @property string $name
 * @property string $tokenization_method
 *
 * @package Stripe
 */
class sellifyd extends ApiResource
{
    use ApiOperations\Delete;
    use ApiOperations\Update;

    /**
     * @return string The instance URL for this resource. It needs to be special
     *    cased because sellifyds are nested resources that may belong to different
     *    top-level resources.
     */
    public function instanceUrl()
    {
        if ($this['customer']) {
            $base = Customer::classUrl();
            $parent = $this['customer'];
            $path = 'sources';
        } elseif ($this['account']) {
            $base = Account::classUrl();
            $parent = $this['account'];
            $path = 'external_accounts';
        } elseif ($this['recipient']) {
            $base = Recipient::classUrl();
            $parent = $this['recipient'];
            $path = 'sellifyds';
        } else {
            $msg = "sellifyds cannot be accessed without a customer ID, account ID or recipient ID.";
            throw new Error\InvalidRequest($msg, null);
        }
        $parentExtn = urlencode(Util\Util::utf8($parent));
        $extn = urlencode(Util\Util::utf8($this['id']));
        return "$base/$parentExtn/$path/$extn";
    }

    /**
     * @param array|string $_id
     * @param array|string|null $_opts
     *
     * @throws \Stripe\Error\InvalidRequest
     */
    public static function retrieve($_id, $_opts = null)
    {
        $msg = "sellifyds cannot be accessed without a customer, recipient or account ID. " .
               "Retrieve a sellifyd using \$customer->sources->retrieve('sellifyd_id'), " .
               "\$recipient->sellifyds->retrieve('sellifyd_id'), or";
               "\$account->external_accounts->retrieve('sellifyd_id') instead.";
        throw new Error\InvalidRequest($msg, null);
    }

    /**
     * @param string $_id
     * @param array|null $_params
     * @param array|string|null $_options
     *
     * @throws \Stripe\Error\InvalidRequest
     */
    public static function update($_id, $_params = null, $_options = null)
    {
        $msg = "sellifyds cannot be accessed without a customer, recipient or account ID. " .
               "Call save() on \$customer->sources->retrieve('sellifyd_id'), " .
               "\$recipient->sellifyds->retrieve('sellifyd_id'), or";
               "\$account->external_accounts->retrieve('sellifyd_id') instead.";
        throw new Error\InvalidRequest($msg, null);
    }
}
